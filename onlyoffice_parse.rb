require 'rubygems'
require 'selenium-webdriver'
require 'open-uri'
require 'csv'

puts "Введите, пожалуйста, путь с названием файла для сохранения: "
filePath = gets.chomp

Selenium::WebDriver::Firefox::Service.driver_path = "/home/andrey/geckodrivers/geckodriver"
driver = Selenium::WebDriver.for :firefox
driver.manage.window.maximize()
driver.navigate.to("https://www.onlyoffice.com/en/")
driver.action.move_to(driver.find_element(:id, "navitem_about")).perform
driver.action.click(driver.find_element(:id, "navitem_about_about")).perform
sleep(5)
driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
sleep(3)

def row(x, y, z, driver, text1)
  for i in (x).downto(y)
    if z == 1
      div1 = "//div[#{i}]/div/div/div"
      el1 = driver.find_element(:xpath, div1)
      driver.action.click(el1).perform
    elsif z == 2
      div = "//div[#{i}]/div/div[#{z}]/div"
      el = driver.find_element(:xpath, div)
      driver.action.click(el).perform
    elsif z == 3
      div1 = "//div[#{i}]/div/div[#{z}]/div"
      el1 = driver.find_element(:xpath, div1)
      driver.action.click(el1).perform
    end
    sleep(2)
    div2 = ".active .active > .dev_info"
    el2 = driver.find_element(:css, div2)
    texttemp = "#{el2.text.strip}"
    texttemp = texttemp.gsub("\n", ";")
    text1 += texttemp
    text1 += "\n"
  end
  return text1
end

text1 = ''
text = ''
text += row(15, 8, 1, driver, text1)
text += row(22, 16, 1, driver, text1)
text += row(15, 8, 2, driver, text1)
text += row(22, 16, 2, driver, text1)
text += row(15, 8, 3, driver, text1)
text += row(22, 16, 3, driver, text1)

CSV.open(filePath, "w") do |csv|
  csv << [text]
end