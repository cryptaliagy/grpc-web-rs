<script lang="ts">
	import { HelloRequest } from '$lib/helloworld';
	import { GreeterClient } from '$lib/helloworld.client';
	import { GrpcWebFetchTransport } from '@protobuf-ts/grpcweb-transport';

	let message = 'This will be replaced by the response from the server.';

	const sendRequest = async () => {
		let transport = new GrpcWebFetchTransport({ baseUrl: 'http://localhost:8080' });
		let client = new GreeterClient(transport);

		let request = HelloRequest.create({ name: 'Client' });

		try {
			let response = await client.sayHello(request);
			message = response.response.message;
		} catch (error) {
			message = `Error: ${error}`;
		}
	};
</script>

<h1>Example Application for Testing Envoy Integration</h1>

<p>{message}</p>
<button on:click={sendRequest}>Send Request</button>
