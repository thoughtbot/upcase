Then /^I should see a link to chat with thoughtbot$/ do
  page.should have_selector('a[data-role="chat-with-thoughtbot"]')
end
