use protobuf_build::helloworld::greeter_server::{Greeter, GreeterServer};
use protobuf_build::helloworld::{HelloReply, HelloRequest};

use tonic::{transport::Server, Request, Response, Status};

#[derive(Default)]
struct MyGreeter {}

#[tonic::async_trait]
impl Greeter for MyGreeter {
    async fn say_hello(
        &self,
        request: Request<HelloRequest>,
    ) -> Result<Response<HelloReply>, Status> {
        let name = request.into_inner().name;

        let response = HelloReply {
            message: format!("Hello, {}!", name),
        };

        Ok(Response::new(response))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::]:50051".parse().unwrap();
    let greeter = MyGreeter::default();

    let server_future = Server::builder()
        .add_service(GreeterServer::new(greeter))
        .serve(addr);

    println!("Server listening on {}", addr);

    server_future.await?;

    Ok(())
}
