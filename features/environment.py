"""
Environment for Behave Testing
"""
import logging
from os import getenv
from selenium import webdriver
from selenium.common.exceptions import WebDriverException

WAIT_SECONDS = int(getenv('WAIT_SECONDS', '30'))
BASE_URL = getenv('BASE_URL', 'http://localhost:8080')
DRIVER = getenv('DRIVER', 'firefox').lower()


def before_all(context):
    """ Executed once before all tests """
    context.base_url = BASE_URL
    context.wait_seconds = WAIT_SECONDS
    # Select either Chrome or Firefox
    if 'firefox' in DRIVER:
        try:
            context.driver = get_firefox()
        except WebDriverException as primary_error:
            logging.exception("Failed to create Firefox driver; falling back to Chrome")
            try:
                context.driver = get_chrome()
            except WebDriverException as fallback_error:
                raise WebDriverException(
                    f"Failed to create Firefox driver ({primary_error}) "
                    f"and fallback Chrome driver ({fallback_error})"
                ) from fallback_error
    else:
        try:
            context.driver = get_chrome()
        except WebDriverException as primary_error:
            logging.exception("Failed to create Chrome driver; falling back to Firefox")
            try:
                context.driver = get_firefox()
            except WebDriverException as fallback_error:
                raise WebDriverException(
                    f"Failed to create Chrome driver ({primary_error}) "
                    f"and fallback Firefox driver ({fallback_error})"
                ) from fallback_error
    context.driver.implicitly_wait(context.wait_seconds)
    context.config.setup_logging()


def after_all(context):
    """ Executed after all tests """
    context.driver.quit()

######################################################################
# Utility functions to create web drivers
######################################################################

def get_chrome():
    """Creates a headless Chrome driver"""
    options = webdriver.ChromeOptions()
    options.add_argument("--no-sandbox")
    options.add_argument("--headless")
    return webdriver.Chrome(options=options)


def get_firefox():
    """Creates a headless Firefox driver"""
    options = webdriver.FirefoxOptions()
    options.add_argument("--headless")
    return webdriver.Firefox(options=options)    
    