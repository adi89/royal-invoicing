class InvoicesPostMailer < ActionMailer::Base
  default :from => "adityas@eden.rutgers.edu"
  def publish_post(billing_doc_id, user_id)
    @user = User.find(user_id)
    @user_email = @user.email
    @billing_doc = Invoice.find(billing_doc_id)
    @emails = @billing_doc.contacts.map{|i| i.email}.join(' , ')
    mail :to => @emails, :subject => "Here is a copy of your  #{@billing_doc.kind}"
  end

end