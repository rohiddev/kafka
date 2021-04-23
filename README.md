# kafka
1. oc new-project amq-demo-streams

2. Install AMQ_streams operator to project amq-demo-streams

Create Cluster
vi my-cluster.yaml
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: my-cluster
spec:
  kafka:
    replicas: 3
    listeners:
      - name: external
        port: 9092
        type: route
        tls: true
    storage:
      type: ephemeral
  zookeeper:
    replicas: 3
    storage:
      type: ephemeral
  entityOperator:
    topicOperator: {}
    
    oc create -f my-cluster.yaml
    
 3. create topic
 vi my-topic.yaml
 apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: my-topic
  labels:
    strimzi.io/cluster: my-cluster
spec:
  partitions: 3
  replicas: 3
  
  oc create -f my-topic.yaml
  
  4. oc extract secret/my-cluster-cluster-ca-cert --keys=ca.crt --to=- > ca.crt
  5. keytool -import -trustcacerts -alias root -file ca.crt -keystore keystore.jks -storepass password -noprompt
  6. cat keystore.jks| base64
  7. vi my-secret.yaml 
  
  apiVersion: v1
kind: Secret
metadata:
  name: my-secret
  namespace: amq-demo-streams
data:
  keystore.jks: "<base 64 from previous command here>"
  
  8. deploy app using https://github.com/rohiddev/kafka
  9. add the below to deployment.yaml 
  
        volumes:
         - name: secrets
           secret:
             secretName: my-secret
             items:
               - key: keystore.jks
                 path: keystore.jks
                 
            volumeMounts:
             - name: secrets
               mountPath: /mnt/secrets
               readOnly: true
               
     10 . oc get routes my-cluster-kafka-external-bootstrap -o=jsonpath='{.status.ingress[0].host}{"\n"}'
     
     Add this output to 
     rops.put("bootstrap.servers", "my-cluster-kafka-external-bootstrap-amq-demo-streams.apps.domain.com:443");
  
  
    
    
