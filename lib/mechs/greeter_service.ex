defmodule Mechs.GreeterService do
  use GRPC.Service, otp_app: :mechs, service: Helloworld.Greeter.Service

  alias Helloworld.HelloRequest
  alias Helloworld.HelloReply

  def say_hello(%HelloRequest{name: name}, _stream) do
    message = "Hello, #{name}!"
    reply = %HelloReply{message: message}
    {:reply, reply}
  end
end
