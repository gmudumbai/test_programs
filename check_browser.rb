#x = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"
#x = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20100101 Firefox/23.0"
x = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"

browser = x.match(/MSIE [0-9]+/).to_s
@ie = false     
if !browser.empty? && browser.match(/\d+/).to_s.to_i <= 9
    @ie = true
end

puts @ie