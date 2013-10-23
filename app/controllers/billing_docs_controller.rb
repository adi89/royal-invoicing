class BillingDocsController < ApplicationController

def index
end

def new
  @billing_doc = BillingDoc.new
  params["kind"] == "Invoice" ? @billing_doc.invoice : @billing_doc.estimate
  @billing_doc.line_items.build
    binding.pry
    render  'new'
  end


end