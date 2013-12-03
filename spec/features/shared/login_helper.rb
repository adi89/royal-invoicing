module LoginHelper
  def login_to_system(user)
    click_link('Sign In')
    fill_in('Email', :with => user.email)
    fill_in('Password', :with => user.password)
    click_button('Sign in')
  end
end