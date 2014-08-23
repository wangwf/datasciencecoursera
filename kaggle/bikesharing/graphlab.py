import graphlab as gl

# load training data
training_sframe = gl.SFrame.read_csv('train.csv')

# train a model
features = ['datetime', 'season', 'holiday', 'workingday', 'weather',
            'temp', 'atemp', 'humidity', 'windspeed']
m = gl.boosted_trees.create(training_sframe,
                            feature_columns=features, 
                            target_column='count', objective='regression',
                            num_iterations=100)

# predict on test data
test_sframe = gl.SFrame.read_csv('test.csv')
prediction = m.predict(test_sframe)


def make_submission(prediction, filename='submission.txt'):
    with open(filename, 'w') as f:
        f.write('datetime,count')
        submission_strings = test_sframe['datetime'] + ',' + prediction.astype(str)
        for row in submission_strings:
            f.write(row + '\n')

make_submission(prediction, 'submission1.txt')
