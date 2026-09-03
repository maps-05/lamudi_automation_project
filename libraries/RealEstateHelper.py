import os
import re
import time

try:
    from openai import OpenAI
except ImportError:
    OpenAI = None

from dotenv import load_dotenv

load_dotenv(".env")


class RealEstateHelper:
    """Custom library for real estate data manipulation and AI validations."""

    def clean_and_convert_price(self, price_string):
        """Converts a price string like '₱ 1,500,000' or 'Contact for price' into a float."""
        if not price_string or "contact" in price_string.lower():
            return 0.0

        cleaned = re.sub(r"[^\d.]", "", price_string)
        return float(cleaned) if cleaned else 0.0

    def validate_prices_are_within_budget(self, prices_list, max_budget):
        """Asserts parsed prices do not exceed the max budget."""
        max_budget = float(max_budget)
        for raw_price in prices_list:
            actual_price = self.clean_and_convert_price(raw_price)
            if actual_price > max_budget and actual_price != 0.0:
                raise AssertionError(
                    f"Price {actual_price} exceeds budget of {max_budget}"
                )
        return True

    def ai_validate_listing_vibe(self, listing_description, expected_vibe):
        """Strict AI validator using the OpenAI SDK routed through Groq's free API."""
        api_key = os.getenv("GROQ_API_KEY")

        if not api_key:
            raise AssertionError("FAIL: No API key detected. Add GROQ_API_KEY to your .env file.")

        if not OpenAI:
            raise ImportError(
                "FAIL: The 'openai' library is not installed."
            )

        clean_key = api_key.replace('"', "").replace("'", "").strip()
        
        # OpenAI client
        client = OpenAI(
            base_url="https://api.groq.com/openai/v1",
            api_key=clean_key
        )

        prompt = (
            f"Analyze this real estate listing description. Does it describe a '{expected_vibe}' property? "
            f"Answer ONLY 'Yes' or 'No'. Listing: {listing_description}"
        )

        for attempt in range(3):
            try:
                
                response = client.chat.completions.create(
                    model="openai/gpt-oss-20b",
                    messages=[{"role": "user", "content": prompt}],
                    temperature=0.0
                )

                answer = response.choices[0].message.content.strip().lower()
                
                print(f"\n[AI] GPT-OSS-20B Response: {answer}")

                if "yes" not in answer:
                    raise AssertionError(
                        f"FAIL: AI determined property does NOT match vibe '{expected_vibe}'. AI Response: {answer}"
                    )

                return True

            except Exception as e:
            
                if "429" in str(e) and attempt < 2:
                    print(
                        f"\n[AI] Rate limit hit. Retrying in 5 seconds... (Attempt {attempt + 2} of 3)"
                    )
                    time.sleep(5)
                else:
                    raise Exception(
                        f"FAIL: AI API call failed. Error details: {str(e)}"
                    )

    def validate_prices_are_within_range(self, prices_list, min_price, max_price):
        """Asserts parsed prices fall within a specific min and max range."""
        min_price = float(min_price)
        max_price = float(max_price)
        
        for raw_price in prices_list:
            actual_price = self.clean_and_convert_price(raw_price)
            
            
            if actual_price == 0.0:
                continue 
                
            if actual_price < min_price or actual_price > max_price:
                raise AssertionError(
                    f"FAIL: Price {actual_price} is outside the allowed range of {min_price} to {max_price}"
                )
        return True

    def calculate_expected_monthly_repayment(self, property_price, deposit_percent, years, interest_rate):
        """Calculates expected mortgage repayment to verify UI accuracy."""
        principal = float(property_price) * (1 - (float(deposit_percent) / 100))
        monthly_interest = (float(interest_rate) / 100) / 12
        num_payments = int(years) * 12
        
        if monthly_interest == 0:
            return round(principal / num_payments, 2)
            
        monthly_payment = principal * (monthly_interest * (1 + monthly_interest)**num_payments) / ((1 + monthly_interest)**num_payments - 1)
        return round(monthly_payment, 2)