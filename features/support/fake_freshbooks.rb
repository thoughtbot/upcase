class FakeFreshbooks
  Client  = Struct.new(:client_id,  :request_doc)
  Invoice = Struct.new(:invoice_id, :request_doc)

  def call(env)
    request = Rack::Request.new(env)
    if '/api/2.1/xml-in' == request.path
      doc = Nokogiri::XML(request.body.read)
      request.body.rewind
      @@requests << doc
      if doc.at('request')['method'] == 'client.create'
        handle_client_create
      elsif doc.at('request')['method'] == 'invoice.create'
        handle_invoice_create
      elsif doc.at('request')['method'] == 'invoice.get'
        handle_invoice_get
      end
    end
  end

  def handle_client_create
    client_id = FakeFreshbooks.next_sequence
    response = <<-END.strip
      <?xml version="1.0" encoding="utf-8"?>
      <response xmlns="http://www.freshbooks.com/api/" status="ok">
        <client_id>#{client_id}</client_id>
      </response>
    END
    @@clients << Client.new(client_id, @@requests.last)
    [200, { 'Content-Length' => response.length, 'Content-Type' => 'application/xml' }, [response] ]
  end

  def handle_invoice_create
    invoice_id = FakeFreshbooks.next_sequence
    response   = <<-END.strip
      invoice response
      <?xml version="1.0" encoding="utf-8"?>
      <response xmlns="http://www.freshbooks.com/api/" status="ok">
        <invoice_id>#{invoice_id}</invoice_id>
      </response>
    END
    @@invoices << Invoice.new(invoice_id, @@requests.last)
    [200, { 'Content-Length' => response.length, 'Content-Type' => 'application/xml' }, [response] ]
  end

  def handle_invoice_get
    request = @@requests.last
    invoice_id = request.at('invoice_id').text.to_i
    invoice = self.class.invoice_by_id(invoice_id)
    invoice_doc = invoice.request_doc
    response = Nokogiri::XML::Builder.new do |xml|
      xml.response :xmlns => 'http://www.freshbooks.com/api/', :status => 'ok' do
        xml.invoice do
          xml.invoice_id invoice.invoice_id
          xml.client_id invoice_doc.at('client_id').text
          xml.links do
            xml.client_view "https://thoughtbot.freshbooks.com/view/#{invoice.invoice_id}"
          end
        end
      end
    end.to_xml
    [200, { 'Content-Length' => response.length, 'Content-Type' => 'application/xml' }, [response] ]
  end

  def self.reset!
    @@requests = []
    @@clients  = []
    @@invoices = []
    @@current_sequence = 0
  end

  def self.next_sequence
    @@current_sequence += 1
  end

  def self.last_client
    @@clients.last
  end

  def self.last_invoice
    @@invoices.last
  end

  def self.invoice_by_id(id)
    @@invoices.detect { |invoice| invoice.invoice_id == id }
  end
end

Before do
  FakeFreshbooks.reset!
  ShamRack.mount(FakeFreshbooks.new, FRESHBOOKS_PATH, 443)
end
