from os import getenv
from pika import BlockingConnection, ConnectionParameters, PlainCredentials

mqqueue = getenv('RMQ_QUEUE', 'urls')


def callback(ch, method, properties, body):
    return


if __name__ == "__main__":
    try:
        mqhost = "35.197.19.215"
        mqport = 31706
        credentials = PlainCredentials("user", "rabbit-password")
        rabbit = BlockingConnection(ConnectionParameters(
            host=mqhost,
            port=mqport,
            virtual_host="crawler",
            connection_attempts=10,
            retry_delay=1,
            credentials=credentials))
    except Exception as e:
        print("connect_to_MQ crawler Failed connect to MQ")
        print(e)
    else:
        print('connect_to_MQ crawler - Successfully connected to MQ host {}'.format(mqhost))

    channel = rabbit.channel()

    channel.basic_consume(callback,
                      queue=mqqueue)
    channel.start_consuming()
