```python
spark-submit \
  --master spark://spark-master-host:7077 \
  --deploy-mode cluster \
  --executor-memory 4G \
  --total-executor-cores 4 \
  --name MySparkApp \
  --conf spark.executor.memoryOverhead=1G \
  path/to/your/my_pyspark_script.py


```

### CLUSTER OPTIONS
- Kubernetes
- YARN
- Stanalone Cluster

Spark Submit is present in the /bin directory
```python
spark-submit \
  --master k8s://https://<kubernetes-master>:<3903> \
  --deploy-mode cluster \
  --name spark-on-k8s-example \
  --class org.apache.spark.deploy.PythonRunner \
  --conf spark.executor.instances=2 \
  --conf spark.kubernetes.container.image=your-docker-repo/spark-app:latest \
  --conf spark.kubernetes.namespace=default \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
  --conf spark.kubernetes.container.image.pullPolicy=Always \
  local:///opt/spark/work-dir/my_pyspark_script.py


```