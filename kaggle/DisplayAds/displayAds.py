
# coding: utf-8

# In[1]:

import graphlab as gl

# load training data
training_column_types = [str, int,
                         int, int, int, int, int, int, int, int, int, int,
                         int, int, int,
                         str, str, str, str, str, str, str, str, str, str,
                         str, str, str, str, str, str, str, str, str, str,
                         str, str, str, str, str, str]

training_sframe = gl.SFrame.read_csv('train.csv', column_type_hints=training_column_types, nrows=10000000) #rows=
#raining_sframe.show()

#test = gl.SFrame.read_csv('test.csv', column_type_hints=training_column_types)
#test.show()

# load test data
test_column_types     = [str,
                         int, int, int, int, int, int, int, int, int, int,
                         int, int, int,
                         str, str, str, str, str, str, str, str, str, str,
                         str, str, str, str, str, str, str, str, str, str,
                         str, str, str, str, str, str]
test_sframe = gl.SFrame.read_csv('test.csv', column_type_hints=test_column_types) # nrows = 1000)



# In[2]:

training_sframe.head()


# In[4]:

#training_good,training_bad=training_sframe.dropna_split()
features = ['I1', 'I2', 'I3', 'I4', 'I5', 'I6','I7', 'I8', 'I9','I10',
            'I11', 'I12', 'I13',
            'C1', 'C2', 'C3','C4', 'C5', 'C6','C7', 'C8', 'C9','C10',
            'C11', 'C12', 'C13','C14', 'C15', 'C16','C17', 'C18', 'C19','C20',
            'C21', 'C22', 'C23','C24', 'C25', 'C26']


# In[5]:

# Missing Values
for f in features:    
    if (f[0]=="I"): training_sframe.fillna(f, training_sframe[f].mean())
    #print test_sframe[f].dtype(), f[0]
    #print test_sframe[f].mean()
(train_set, test_set) = training_sframe.random_split(0.8, seed=1)


# In[7]:

# train a model
m1 = gl.boosted_trees.create(train_set,  #training_sframe,
                            features=features, 
                            target='Label', objective='classification',
                            num_iterations=100)


# In[12]:

# test the prediction of training sample
pred1 = m1.predict(train_set)
# Confusion matrix
gl.evaluation.confusion_matrix(train_set['Label'], pred1)  # threshold
gl.evaluation.accuracy(train_set['Label'], pred1)


# In[16]:

# Confusion matrix
print gl.evaluation.confusion_matrix(test_set['Label'], pred1)  # threshold
print gl.evaluation.accuracy(test_set['Label'], pred1)


# In[13]:

import numpy as np
def rmse(predictions, targets):
    return np.sqrt( ((predictions - targets) *(predictions - targets)).mean())
rmse(train_set['Label']+1, pred1)


# In[14]:

# validation sample
pred1 = m1.predict(test_set)
rmse(test_set['Label']+1, pred1)


# In[15]:

# Confusion matrix
gl.evaluation.confusion_matrix(test_set['Label'], pred1)  # threshold
gl.evaluation.accuracy(test_set['Label'], pred1)


# In[ ]:

# test set
for f in features:    
    #test_sframe[f] = test_sframe[f].apply(lambda x : 0  )
    print f,test_sframe[f].head(3)
    if (f[0]=="I"): test_sframe.fillna(f, test_sframe[f].mean())    


# In[ ]:

# predict on test data
prediction = m.predict(test_sframe)  #sframe)
prediction = prediction.astype(int)


# In[ ]:

#submission
def make_submission(prediction, filename='submission.txt'):
    with open(filename, 'w') as f:
        f.write('Id,Predicted\n')
        submission_strings = test_sframe['Id'] + ',' + prediction.astype(str)
        for row in submission_strings:
            f.write(row + '\n')

make_submission(prediction, 'submission1.txt')


# In[ ]:

#Define the search space
ntrees = 500
search_space = {
    'params': {
        'max_depth': [10],
        'min_child_weight': [5, 20],
        'step_size': 0.05,
    },
    'num_iterations': [ntrees]
}

def parameter_search(training_url, validation_url, default_params):
    """
    Return the optimal parameters in the given search space.
    The parameter returned has the lowest validation rmse.
    """
    job = gl.toolkits.model_parameter_search(env, gl.boosted_trees.create,
                                             train_set_path=training_url,
                                             save_path='/tmp/job_output',
                                             standard_model_params=default_params,
                                             hyper_params=search_space,
                                             test_set_path=validation_url)


    # When the job is done, the result is stored in an SFrame
    # The result contains attributes of the models in the search space
    # and the validation error in RMSE. 
    result = gl.SFrame('/tmp/job_output').sort('rmse', ascending=True)

    # Return the parameters with the lowest validation error. 
    optimal_params = result[['max_depth', 'min_child_weight']][0]
    optimal_rmse = result['rmse'][0]
    print 'Optimal parameters: %s' % str(optimal_params)
    print 'RMSE: %s' % str(optimal_rmse)
    return optimal_params


# In[ ]:

env = gl.deploy.environment.Local('hyperparam_search')

train_set.save("/tmp/train_set")
test_set.save("/tmp/test_set")


# In[ ]:

#Perform hyperparameter search
fixed_params = {'features': features,
                'target':'Label',
                'verbose': False
                }
#Perform hyperparameter search 

params_found = parameter_search('/tmp/train_set',
                                         '/tmp/test_set',
                                         fixed_params)


# In[ ]:

#result = gl.SFrame('/tmp/job_output1').sort('rmse', ascending=True)
#result
params_found


# In[ ]:

#Train models with the tuned hyperparameters
#Doing hyperparameter search requires us to hold out a validation set from the original training data. In the final submission, we want to train models that take full advantages of the provided training data.

m2 = gl.boosted_trees.create(training_sframe,
                                           features=features,
                                           target='Label',
                                           num_iterations=ntrees,
                                           params=params_found,
                                           verbose=False)


# predict on test data
prediction2 = m2.predict(test_sframe)  #sframe)
prediction2 = prediction.astype(int)


make_submission(prediction2, 'submission2.txt')


# In[ ]:



