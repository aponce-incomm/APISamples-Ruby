#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'
require 'json'
include REXML

#Settings
APIURL = 'https://sandbox.thesecuregateway.com/rest/v1/transactions'
APIKEY = 'a20effd6dc1d4512888e6b06d870248a'
TIMEOUT = 15
LANG_TYPE = 'json' #'xml' or 'json'

#Transaction xml model
def buildXML()
    xml_request = "<?xml version=\"1.0\" encoding=\"utf-8\"?>
    <transaction>
        <api_key>%{apikey}</api_key>
        <type>%{type}</type>
        <card>%{card_number}</card>
        <csc>%{card_csc}</csc>
        <exp_date>%{expiry_date}</exp_date>
        <amount>%{amount}</amount>
        <avs_address>%{avs_address}</avs_address>
        <avs_zip>%{avs_zip}</avs_zip>
        <email>%{email}</email>
        <customer_id>%{customer_id}</customer_id>
        <order_number>%{order_number}</order_number>
        <purchase_order>%{purchase_order}</purchase_order>
        <invoice>%{invoice}</invoice>
        <client_ip>%{client_ip}</client_ip>
        <description>%{description}</description>
        <comments>%{comments}</comments>
        <billing>
            <first_name>%{billing_first_name}</first_name>
            <last_name>%{billing_last_name}</last_name>
            <company>%{billing_company}</company>
            <street>%{billing_address1}</street>
            <street2>%{billing_address2}</street2>
            <city>%{billing_city}</city>
            <state>%{billing_state}</state>
            <zip>%{billing_zip}</zip>
            <country>%{billing_country}</country>
            <phone>%{billing_phone}</phone>
        </billing>
        <shipping>
            <first_name>%{shipping_first_name}</first_name>
            <last_name>%{shipping_last_name}</last_name>
            <company>%{shipping_company}</company>
            <street>%{shipping_address1}</street>
            <street2>%{shipping_address2}</street2>
            <city>%{shipping_city}</city>
            <state>%{shipping_state}</state>
            <zip>%{shipping_zip}</zip>
            <country>%{shipping_country}</country>
            <phone>%{shipping_phone}</phone>
        </shipping>
    </transaction>" % { #Transaction Info
    :apikey => APIKEY,
    :type => 'SALE',
    :card_number => '4111111111111111',
    :card_csc => '123',
    :expiry_date => '1121',
    :amount => '10.00',
    :avs_address => '112 N. Orion Court',
    :avs_zip => '20210',
    :purchase_order => '10',
    :invoice => '100',
    :email => 'email@tsg.com',
    :customer_id => '25',
    :order_number => '1000',
    :client_ip => '',
    :description => 'Cel Phone',
    :comments => 'Electronic Product',
    :billing_first_name => 'Joe',
    :billing_last_name => 'Smith',
    :billing_company => 'Company Inc.',
    :billing_address1 => 'Street 1',
    :billing_address2 => 'Street 2',
    :billing_city => 'Jersey City',
    :billing_state => 'NJ',
    :billing_zip => '07097',
    :billing_country => 'USA',
    :billing_phone => '123456789',
    :shipping_first_name => 'Joe',
    :shipping_last_name => 'Smith',
    :shipping_company => 'Company 2 Inc.',
    :shipping_address1 => 'Street 1 2',
    :shipping_address2 => 'Street 2 2',
    :shipping_city => 'Colorado City',
    :shipping_state => 'TX',
    :shipping_zip => '79512',
    :shipping_country => 'USA',
    :shipping_phone => '123456789'
    }
   return xml_request
end

#Transaction json model
def buildJSON()
    json_request = "{
	\"api_key\": \"%{apikey}\",
    \"type\": \"%{type}\",
    \"card\": \"%{card_number}\",
    \"csc\": \"%{card_csc}\",
    \"exp_date\": \"%{expiry_date}\",
    \"amount\": \"%{amount}\",
    \"email\": \"%{email}\",
    \"customer_id\": \"%{customer_id}\",
	\"order_number\": \"%{order_number}\",
	\"purchase_order\": \"%{purchase_order}\",
	\"invoice\": \"%{invoice}\",              
    \"client_ip\": \"%{client_ip}\",
    \"description\": \"%{description}\",
	\"comments\": \"%{comments}\",
    \"billing\": {
      \"first_name\": \"%{billing_first_name}\",
      \"last_name\": \"%{billing_last_name}\",
      \"company\": \"%{billing_company}\",
      \"street\": \"%{billing_address1}\",
	  \"street2\": \"%{billing_address2}\",
      \"city\": \"%{billing_city}\",
      \"state\": \"%{billing_state}\",
      \"zip\": \"%{billing_zip}\",
      \"country\": \"%{billing_country}\",
      \"phone\": \"%{billing_phone}\"
    },
    \"shipping\": {
      \"first_name\": \"%{shipping_first_name}\",
      \"last_name\": \"%{shipping_last_name}\",
      \"company\": \"%{shipping_company}\",
      \"street\": \"%{shipping_address1}\",
	  \"street2\": \"%{shipping_address2}\",
      \"city\": \"%{shipping_city}\",
      \"state\": \"%{shipping_state}\",
      \"zip\": \"%{shipping_zip}\",
      \"country\": \"%{shipping_country}\",
      \"phone\": \"%{shipping_phone}\"
    }
}" % { #Transaction Info
    :apikey => APIKEY,
    :type => 'SALE',
    :card_number => '4111111111111111',
    :card_csc => '123',
    :expiry_date => '1121',
    :amount => '10.00',
    :purchase_order => '10',
    :invoice => '100',
    :email => 'email@tsg.com',
    :customer_id => '25',
    :order_number => '1000',
    :client_ip => '',
    :description => 'Cel Phone',
    :comments => 'Electronic Product',
    :billing_first_name => 'Joe',
    :billing_last_name => 'Smith',
    :billing_company => 'Company Inc.',
    :billing_address1 => 'Street 1',
    :billing_address2 => 'Street 2',
    :billing_city => 'Jersey City',
    :billing_state => 'NJ',
    :billing_zip => '07097',
    :billing_country => 'USA',
    :billing_phone => '123456789',
    :shipping_first_name => 'Joe',
    :shipping_last_name => 'Smith',
    :shipping_company => 'Company 2 Inc.',
    :shipping_address1 => 'Street 1 2',
    :shipping_address2 => 'Street 2 2',
    :shipping_city => 'Colorado City',
    :shipping_state => 'TX',
    :shipping_zip => '79512',
    :shipping_country => 'USA',
    :shipping_phone => '123456789'
    }
   return json_request
end

#parse XML response according to its content
def parseXMLResponse(res)
    xmldoc = Document.new(res.body)
    puts xmldoc
            
    #Result Code
    result_code = XPath.first(xmldoc, "//transaction/result_code")
    
    if result_code and result_code.text == "0000"
        #Authorization Code
        authorization_code = XPath.first(xmldoc, "//transaction/authorization_code")
        puts "-----------------------------------------------------\n"
        puts "TRANSACTION APPROVED: " + authorization_code.text
    else
        res_code = ""
        #Error Info
        display_message = XPath.first(xmldoc, "//transaction/display_message")
        error_code = XPath.first(xmldoc, "//transaction/error_code")
        if error_code
            res_code = error_code.text
        end
        if result_code
            res_code = result_code.text
        end
        
        puts "-----------------------------------------------------\n"
        puts "TRANSACTION ERROR: Code=" + res_code + " Message=" + display_message.text
    end    
end

#parse JSON response according to its content
def parseJSONResponse(res)
    temp = JSON.parse(res.body)
    jsondoc = temp["transaction"]
    puts jsondoc
            
    #Result Code
    if jsondoc["result_code"] and jsondoc["result_code"] == "0000"
        #Authorization Code
        authorization_code = jsondoc["authorization_code"]
        puts "-----------------------------------------------------\n"
        puts "TRANSACTION APPROVED: " + authorization_code
    else
        res_code = ""
        #Error Info
        display_message = jsondoc["display_message"]
        error_code = jsondoc["error_code"]
        if error_code
            res_code = error_code
        end
        if jsondoc["result_code"]
            res_code = jsondoc["result_code"]
        end
        
        puts "-----------------------------------------------------\n"
        puts "TRANSACTION ERROR: Code=" + res_code + " Message=" + display_message
    end    
end

begin   
    url = URI.parse(APIURL)
    req = Net::HTTP::Post.new(url.path,initheader = {'Content-Type' =>'application/'+LANG_TYPE})
    
    #check for xml or json to build the request
    if LANG_TYPE == 'xml'
        request = buildXML()
    else
        request = buildJSON()
    end
    puts request
     
    #Http Request
    req.body = request
    sock = Net::HTTP.new(url.host, url.port)
    sock.use_ssl = true
    sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
    sock.open_timeout = TIMEOUT
    sock.read_timeout = TIMEOUT
    res = sock.start {|http| http.request(req) }

    case res
        when Net::HTTPSuccess, Net::HTTPRedirection #http status 200
        #check for xml or json to parse the response according to its content
            if LANG_TYPE == 'xml'
                request = parseXMLResponse(res) # if the chosen language was XML, then the server will respond back with XML
            else
                request = parseJSONResponse(res) # if the chosen language was JSON, then the server will respond back with JSON
            end          
        else
            puts "-----------------------------------------------------\n"
            puts "INVALID RESPONSE\n"
    end

rescue Exception => e  
    puts "-----------------------------------------------------\n"
    puts "EXCEPTION: " + e.message ;
end
