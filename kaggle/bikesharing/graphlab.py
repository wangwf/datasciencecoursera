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

def make_submission(prediction, filename='submission.txt'):
    with open(filename, 'w') as f:
        f.write('datetime,count\n')
        submission_strings = test_sframe['datetime'] + ',' + prediction.astype(str)
        for row in submission_strings:
            f.write(row + '\n')

make_submission(prediction, 'submission1.txt')
