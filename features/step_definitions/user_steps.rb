Given /^the following users:$/ do |users|
  users.hashes.each do |hash|
    User.create!(hash)
  end
end

Given /^only user with email "([^\"]*)", password "([^\"]*)"$/ do |email, pass|
  User.create(
    :email                 => email,
    :password              => pass,
    :password_confirmation => pass
  )
end

Given /^I am logged in as "([^\"]*)"$/ do |email|
  User.create(
    :email                 => email,
    :password              => 'password',
    :password_confirmation => 'password')

  visit "/login"
  fill_in("username",    :with => email)
  fill_in("password", :with => "password")
  click_button("Log in")
end

When /^I delete the (\d+)(?:st|nd|rd|th) user$/ do |pos|
  visit users_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following users:$/ do |users|
  users.rows.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end