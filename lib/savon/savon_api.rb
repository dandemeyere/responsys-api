class SavonApi
  attr_accessor :client

  def initialize(wsdl)
    # @client = Savon.client(log_level: :debug, log: false, pretty_print_xml: true, wsdl: wsdl)

    # should use this, the call above is only to help debug
    @client = Savon.client(wsdl: wsdl)
  end

  def run(method, message)
    @client.call(method.to_sym, message: message)
  end

  def run_with_credentials(method, message, cookie, header)
    @client.call(method.to_sym, message: message, cookies: cookie, soap_header: header)
  end

  def available_operations
    @client.operations
  end
end
