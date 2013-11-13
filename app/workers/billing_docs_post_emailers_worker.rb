class InvoicesMailerEmailersWorker
  include Sidekiq::Worker
   sidekiq_options retry: false
  def perform(id, options = {})
    @billing_doc = BillingDoc.find(id)
    @user = User.find(options["user_id"])
      InvoicesMailer.publish_post(@billing_doc.id, @user.id).deliver
    end

end
