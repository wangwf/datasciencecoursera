import graphlab
import os
env = graphlab.deploy.environments("async")
data_dir = ""
results_path = ""
train_url = os.path.join(data_dir, "kaggle-bike-train")
test_url = os.path.join(data_dir,"kaggle-bike-test")

#boosted tree model
standard_model_params = {'target_column':'log(count)','num_iterations':50}

hyper_params ={'step_size':[0.05],
               'max_depth':[8,10,15],
               'min_child_weight':[5,10]
               }
job = graphlab.toolkits.model_parameter_search(env, graphlab.boosted_trees_ ,
                                               train_set = train_url,
                                               save_path = results_path,
                                               standard_model_parameter=standard_model_params,
                                               hyper_params = hyper_params,
                                               test_set = test_url)

#Run Asynchronously 
job
result = graphlab.SFrame(results_path).sort('rmse', ascending = True)
result[['step_size','max_depth', 'min_child_weight', 'rmse']]
