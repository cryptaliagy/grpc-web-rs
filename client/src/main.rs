use protobuf_build::helloworld::greeter_client::GreeterClient;
use protobuf_build::helloworld::HelloRequest;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();

    let host = if args.len() > 1 { &args[1] } else { "[::1]" };

    let mut client = GreeterClient::connect(format!("http://{host}:50051")).await?;

    let request = tonic::Request::new(HelloRequest {
        name: "Tonic".into(),
    });

    let response = client.say_hello(request).await?;

    println!("RESPONSE={:?}", response);

    Ok(())
}
