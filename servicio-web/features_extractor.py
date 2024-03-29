import ipaddress
import re
import requests
from datetime import date
from dateutil.parser import parse as date_parse
from urllib.parse import urlparse
import tldextract
import sys
import time
from bs4 import BeautifulSoup
import dns.resolver

# Calculates number of months
def diff_month(d1, d2):
    return (d1.year - d2.year) * 12 + d1.month - d2.month

def checkLastFeature(dataset):
    value = dataset[-1]
    if value == 1:
        print(" Feature is Phishing")
    elif value == 0:
        print(" Feature is Suspicious")
    else:
        print(" Feature is Legit")

# Generate data set by extracting the features from the URL
def generate_data_set(url):
    start = time.time()
    data_set = []

    # -1 Not phishing
    # 0 suspicious
    # 1 Phishing

    # Converts the given URL into standard format
    if not re.match(r"^https?", url):
        url = "http://" + url

    print("URL: {0:s}".format(url))

    # Extracts domain from the given URL

    domain = re.findall(r"://([^/]+)/?", url)[0]
    print("Domain: {0:s}".format(domain))

    # having_IP_Address
    print("1. Checking if URL has IP")
    try:
        ipaddress.ip_address(domain)
        data_set.append(1)
    except:
        # After setup is finished try to check for http://0x58.0xCC.0xCA.0x62/2/paypal.ca/index.html
        data_set.append(-1)

    checkLastFeature(data_set)

    # URL_Length
    print("2. Checking URL length")
    if len(url) < 54:
        data_set.append(-1)
    elif len(url) >= 54 and len(url) <= 75:
        data_set.append(0)
    else:
        data_set.append(1)

    checkLastFeature(data_set)

    # Shortening_Service
    print("3. Checking Shortening service")
    if re.findall("goo.gl|bit.ly|tinyurl.com|tiny.cc|lc.chat|is.gd|soo.gd|s2r.co|t.co|youtu.be|ow.ly|adf.ly|bit.do|cutt.ly|buff.ly|mcaf.ee|su.pr|bud.url|moourl.com", url):
        data_set.append(1)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)

    # having_At_Symbol
    print("4. Checking URL has @")
    if re.findall("@", url):
        data_set.append(1)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)

    # double_slash_redirecting
    print("5. URL contains double slash redirecting")
    if re.findall(r"[^https?:]//", url):
        data_set.append(1)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)

    # Prefix_Suffix
    print("6. Checking URL has preffix-suffix")
    if re.findall(r"https?://[^\-]+-[^\-]+/", url):
        data_set.append(1)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)


    # url extract
    extraction = tldextract.extract(url)

    # having_Sub_Domain
    print("7. Checking if domain has multiple subdomains")
    subdomains = extraction.subdomain
    if len(re.findall(r"\.", subdomains)) == 0:
        data_set.append(-1)
    elif len(re.findall(r"\.", subdomains)) == 1:
        data_set.append(0)
    else:
        data_set.append(1)

    checkLastFeature(data_set)

    # HTTPS_token
    print("8. URL has https")
    url_parsed = urlparse(url)
    scheme = url_parsed.scheme
    if scheme == "https":
        data_set.append(-1)
    else:
        data_set.append(1)

    checkLastFeature(data_set)

    # port
    print("9. Check if domain has a port set")
    try:
        netloc = url_parsed.netloc
        port = netloc.split(":")[1]
        if port:
            data_set.append(1)
        else:
            data_set.append(-1)
    except:
        data_set.append(-1)

    checkLastFeature(data_set)

    # Get url html page
    try:
        response = requests.get(url, timeout=5)
        webpage_content = response.text
    except:
        response = ""
        webpage_content = ""

    # Submitting_to_email
    print("10. Checking if HTML is submitting information to email")
    if re.findall(r"[mail\(\)|mailto:?]", webpage_content):
        data_set.append(1)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)

    # Abnormal_URL
    print("11. Checking if it's an Abnormal URL (has content)")
    if webpage_content == "":
        data_set.append(1)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)

    # Redirect
    print("12. Checking URL response has redirect pages")
    # checked by looking at the responses generated by request since it needs to redirect
    try:
        if len(response.history) <= 1:
            data_set.append(-1)
        elif len(response.history) <= 4:
            data_set.append(0)
        else:
            data_set.append(1)
    except:
        data_set.append(-1)

    checkLastFeature(data_set)

    # on_mouseover
    print("13. Checks if response has a onMouseOver event")
    if re.findall("<script>.+onmouseover.+</script>", webpage_content):
        data_set.append(1)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)

    # RightClick
    print("14. Checks if response has a right click event")
    if re.findall(r"event.button ?== ?2", webpage_content):
        data_set.append(1)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)

    # popUpWidnow
    print("15. Checks if response has alert elements that they want to present")
    try:
        if re.findall(r"alert\(", response.text):
            data_set.append(1)
        else:
            data_set.append(-1)
    except:
        data_set.append(-1)

    checkLastFeature(data_set)

    # Iframe
    print("16. Checks if response has iframes or frameBorder elements")
    try:
        if re.findall(r"[<iframe>|<frameBorder>]", response.text):
            data_set.append(1)
        else:
            data_set.append(-1)

    except:
        data_set.append(-1)

    checkLastFeature(data_set)

    # Links_pointing_to_page
    print("17. Checks the amount of link references in the response")
    number_of_links = len(re.findall(r"<a href=", webpage_content))
    if number_of_links == 0:
        data_set.append(1)
    elif number_of_links <= 2:
        data_set.append(0)
    else:
        data_set.append(-1)

    checkLastFeature(data_set)

    try:
        soup = BeautifulSoup(webpage_content, 'html.parser')
    except:
        print("\n\n Crash soup")
        soup = None

    try:
        # URL_of_Anchor -> Check for <a> links inside and compare against hostname
        print("18. Checks the amount of a links that have the same hostname")
        all_a_links = soup.find_all('a', href=True)
        count_a_links = len(all_a_links) if len(all_a_links) > 0 else 1
        count_link_no_domain = 0
        for link in all_a_links:
            href = link['href']
            count_link_no_domain += 1 if isPathExternal(href, domain) else 0
        proportion_external_links = count_link_no_domain / count_a_links
        anchor_tag = -1 if proportion_external_links < 31 else 0 if proportion_external_links > 31 and proportion_external_links < 67 else 1

        print("Number of links objects: {0:d}".format(count_a_links))
        data_set.append(anchor_tag)

        checkLastFeature(data_set)

    except:
        print(sys.exc_info())
        # If there is no response available we can test URL of Anchor
        print("\n\n Crash URL Anchor")
        data_set.append(-1)
        checkLastFeature(data_set)

    try:
        # Request_URL -> Check response of <src elements with the hostname used in the url
        print("19. Checks the amount of a objects that have the same hostname")
        all_images_links = soup.find_all('img')
        count_images_objects = len(all_images_links)
        count_img_no_domain = 0
        for image in all_images_links:
            src = image['src']
            count_img_no_domain += 1 if isPathExternal(src, domain) else 0

        proportion_external_images = count_img_no_domain / count_images_objects
        url_request = -1 if proportion_external_images < 22 else 0 if proportion_external_images > 22 and proportion_external_images < 61 else 1
        data_set.append(url_request)
        checkLastFeature(data_set)
    except:
        data_set.append(-1)
        checkLastFeature(data_set)


    # Requests all the information about the domain
    try:
        whois_response = requests.get("https://www.whois.com/whois/" + domain)
    except:
        whois_response = None

    # Domain_registeration_length
    print("20. Checking for domain expiration date")
    try:
        expiration_date = \
        re.findall(r'Expires On:</div><div class="df-value">([^<]+)</div>', whois_response.text)[0]
        month_age = diff_month(date_parse(expiration_date), date.today())
        if month_age >= 12:
            data_set.append(-1)
        else:
            data_set.append(1)
    except:
        data_set.append(1)

    checkLastFeature(data_set)

    # age_of_domain
    print("21. Checking for domain registration length")
    try:
        registration_date = \
        re.findall(r'Registered On:</div><div class="df-value">([^<]+)</div>', whois_response.text)[0]
        month_age = diff_month(date.today(), date_parse(registration_date))
        if month_age >= 6:
            data_set.append(-1)
        else:
            data_set.append(1)
    except:
        data_set.append(-1)

    checkLastFeature(data_set)

    #needs rank data from
    rank_checker_response = requests.post("https://www.checkpagerank.net/index.php", {
        "name": domain
    })

    # Extracts global rank of the website
    try:
        global_rank = int(re.findall(r"Global Rank: ([0-9]+)", rank_checker_response.text)[0])
    except:
        global_rank = -1

    # web_traffic
    print("22. Checking for Global web traffic rank")
    try:
        if global_rank > 0 and global_rank < 100000:
            data_set.append(-1)
        else:
            data_set.append(1)
    except:
        data_set.append(-1)

    checkLastFeature(data_set)

    # Google_Index
    print("23. Checking for Google Index")
    try:
        isListed = re.findall(r"Google Directory listed: ([A-Z]+)", rank_checker_response.text)[0]
        google_index = -1 if isListed == "YES" else 1
    except:
        google_index = -1

    data_set.append(google_index)

    checkLastFeature(data_set)

    # DNSRecord
    print("24. Checking for DNS records")
    dns_records_count = get_records_count(domain)
    dns_record = 1 if dns_records_count == 0 else -1
    data_set.append(dns_record)
    checkLastFeature(data_set)

    # check run time
    end = time.time()
    print("\nFeature extraction takes approx: {0:f} seconds".format(end-start))


    return data_set

def isPathExternal(path, domain):
    url_parsed = urlparse(path)
    isAbsolutePath = bool(url_parsed.netloc)
    if isAbsolutePath:
        return url_parsed.netloc != domain
    else:
        return False

def get_records_count(domain):
    """
    Get all the records associated to domain parameter.
    :param domain:
    :return:
    """
    ids = [
        'A',
        'AAAA',
        'CAA',
        'CERT',
        'CNAME',
        'DHCID',
        'DNAME',
        'DNSKEY',
        'IPSECKEY',
        'LOC',
        'MX',
        'NAPTR',
        'NSEC',
        'NSEC3',
        'NSEC3PARAM',
        'PTR',
        'RP',
        'RRSIG',
        'SOA',
        'SRV',
        'SSHFP',
        'TLSA',
        'TXT',
        'URI'
    ]

    amount_of_records = 0
    for a in ids:
        try:
            answers = dns.resolver.query(domain, a)
            if len(answers) > 0:
                amount_of_records += 1

        except:
            pass

    return amount_of_records
