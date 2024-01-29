echo "Kafka Topics"
kubectl exec -it kafka-0 -- kafka-topics.sh --list --bootstrap-server kafka:9092

