import asyncio
from kubernetes import client, config, watch

async def watch_ptp_pod_status(namespace, label_selector):
    config.load_incluster_config()
    v1 = client.CoreV1Api()
    w = watch.Watch()
    for event in w.stream(v1.list_namespaced_pod, namespace=namespace, label_selector=label_selector):
        pod = event['object']
        if pod.status.conditions:
            for condition in pod.status.conditions:
                if condition.type == "Ready":
                    node_name = pod.spec.node_name
                    if condition.status == "True":
                        print(f"Pod {pod.metadata.name} on node {node_name} is ready. Consider untainting the node.")
                        # Insert logic here to untaint the node
                    else:
                        print(f"Pod {pod.metadata.name} on node {node_name} is not ready. Consider tainting the node.")
                        # Insert logic here to taint the node

async def main():
    await watch_ptp_pod_status('default', 'app=ptp')

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
