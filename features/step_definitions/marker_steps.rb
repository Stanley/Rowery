Given /^the following markers:$/ do |manage_markers|
  manage_markers.hashes.each do |hash|
    Marker.create!(hash)
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) marker$/ do |pos|
  visit manage_markers_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following markers:$/ do |expected_manage_markers_table|
  expected_manage_markers_table.diff!(table_at('table').to_a)
end
