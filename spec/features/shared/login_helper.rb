module LoginHelper
  def login_to_system(user)
    click_link('Sign In')
    fill_in('Email', :with => user.email)
    fill_in('Password', :with => user.password)
    click_button('Sign in')
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      active = page.evaluate_script('jQuery.active')
      until active == 0
        active = page.evaluate_script('jQuery.active')
      end
    end
  end
end