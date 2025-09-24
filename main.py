from selenium import webdriver
from selenium.webdriver.common.by import By
import pandas as pd

if __name__ == "__main__":
    search_query = str(input("Search on OLX (press enter for 'Car Cover'): "))
    if not search_query:
        search_query = "car-cover"
    else:
        search_query = "-".join(search_query.lower().split(" "))
    url = f"https://www.olx.in/items/q-{search_query}?isSearchCall=true"
    driver = webdriver.Chrome()
    driver.get(url)
    product_cards = driver.find_elements(by=By.CSS_SELECTOR, value="a > div")
    products = []
    for product_data in product_cards:
        data_list = product_data.text.split("\n")
        if product_data.text.lower().startswith("sell") or product_data.text.lower().startswith("all categories"):
            continue
        elif data_list[0] == "FEATURED":
            data_list = data_list[1:]
        products.append(data_list)
    df = pd.DataFrame(products, columns=['Price', 'Title', 'Description', 'Location', 'Uploaded At'])
    print(df)
    df.to_csv("output.csv")
    driver.quit()
