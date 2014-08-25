import graphlab as gl

# load training data
training_sframe = gl.SFrame.read_csv('train.csv', column_type_hints={'count':int})

# train a model
features = ['datetime', 'season', 'holiday', 'workingday', 'weather',
            'temp', 'atemp', 'humidity', 'windspeed']
m = gl.boosted_trees.create(training_sframe,
                            feature_columns=features, 
                            target_column='count', objective='regression',
                            num_iterations=100)


import numpy as np
def rmse(predictions, targets):
    return np.sqrt(((predictions - targets) ** 2).mean())
pred1 = m.predict(training_sfram)
rmse(training_sframe['count'], pred1)

# predict on test data
test_sframe = gl.SFrame.read_csv('test.csv', column_type_hints={'count':int})
prediction = m.predict(test_sframe)
prediction = prediction.astype(int)

## Parse the datetime column
from datetime import datetime
data_format_str = '%Y-%m-%d %H:%M:%S'

def parse_date(date_str):
    """ parse datetime tuple """
    d = datetime.strptime(date_str, date_format_str)
    return {'year':d.year, 'month':d.month, 'day':d.day,
            'hour':d.hour, 'weekday':d.weekday()}

def process_date_column(data_sframe):
    """Split the 'datetime' column of a given sframe"""
    parsed_date = data_sframe['datetime'].apply(parse_date).unpack(column_name_prefix='')
    for col in ['year', 'month', 'day', 'hour', 'weekday']:
        data_sframe[col] = parsed_date[col]

process_date_column(training_sframe)
process_data_column(test_sframe)

## transform target counts into log domain
import math
# create three new columns: log-casual, log-registered, and log-count
for col in ['casual', 'registered', 'count']:
    training_sframe['log-'+col] = training_sframe[col].apply(lambda x: math.log(x+1))

## combine the predictions of separtely trained models
new_features = features + ['year', 'month', 'weekday', 'hour']
new_features.remove('datetime')

m1 = gl.boosted_trees.create(training_sframe, feature_columns = new_features,
                             target_column="log-casual"]
m2 = gl.boosted_trees.create(training_sframe, feature_columns = new_features,
                             target_column="log-registered"]

def fused_predict(m1, m2, test_sframe):
    """
    Fused the prediction of two separately trained models.
    The input models are trained in the log domain.
    Return the combine predictions in the origianl domain.
    """
    p1 = m1.predict(test_sframe).apply(lambda x: math.exp(x)-1)
    p2 = m2.predict(test_sframe).apply(lambda x: math.exp(x)-1)
    return (p1+p2).apply(lambda x: x if x>0 else 0)

prediction =fused_predict(m1, m2, test_sframe)


##submission
def make_submission(prediction, filename='submission.txt'):
    with open(filename, 'w') as f:
        f.write('datetime,count\n')
        submission_strings = test_sframe['datetime'] + ',' + prediction.astype(str)
        for row in submission_strings:
            f.write(row + '\n')

make_submission(prediction, 'submission1.txt')
