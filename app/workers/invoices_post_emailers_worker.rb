class InvoicesPostEmailersWorker
  include Sidekiq::Worker
   sidekiq_options retry: false

  def perform(id, options = {})
    @billing_doc = Invoice.find(id)
    @user = User.find(options["user_id"])
      InvoicesPostMailer.publish_post(@billing_doc.id, @user.id).deliver
    end

end
