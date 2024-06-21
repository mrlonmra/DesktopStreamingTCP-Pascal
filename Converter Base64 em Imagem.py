import base64
import os

def base64_to_image(base64_string, output_path):
    # Debug: Print the length of the base64 string
    print(f"Length of base64 string: {len(base64_string)}")
    
    # Debug: Print the first 100 characters of the base64 string for inspection
    print(f"First 100 characters of base64 string: {base64_string[:100]}")
    
    # Remove any extraneous whitespace or newlines from the base64 string
    base64_string = base64_string.replace('\n', '').replace('\r', '').replace(' ', '')
    
    # Check if the length of the string is a multiple of 4
    if len(base64_string) % 4 != 0:
        # Add padding if necessary
        base64_string += '=' * (4 - len(base64_string) % 4)
    
    try:
        image_data = base64.b64decode(base64_string)
        with open(output_path, 'wb') as output_file:
            output_file.write(image_data)
        print(f"Image saved successfully to {output_path}")
    except base64.binascii.Error as e:
        print(f"Error decoding base64 string: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# Example usage
base64_string = '''Qk02kH4AAAAAADYAAAAoAAAAgAcAADgEAAABACAAAAAAAACQfgAAAAAAAAAAAAAAAAAAAAAAKygc
/ywpHf8rKBz/Kicb/yonG/8rKBz/Kygc/ykmGv8qJxv/Kicb/ysoHP8qJxz/Kicc/ysoHf8oJhv/
JyUa/yknHP8pJxz/Kygd/ysoHf8rKB3/KScc/y0qH/8pJxz/Kygd/ygmG/8pJxz/KScc/ysoHf8r
KB3/KCYb/yknHP8pJxz/LSof/yknHP8rKB3/KCYb/ywpHv8pJxz/Kygd/ywpHv8oJhv/Kygd/ygm
G/8rKB3/KScc/ysoHf8oJhv/KScc/yclGv8sKR7/KScc/ysoHf8oJhv/LCke/ywpHv8rKB3/KCYb
/yknHP8pJxz/Kygd/ysoHf8pJxz/KScc/yknHP8tKh//LCke/ywpHv8sKR7/LCke/y0qH/8sKR7/
Kicc/ykmG/8oJRn/LCke/yonHP8rKB3/Kygd/ywpHv8qJxz/Kygd/ykmGv8pJhr/Kygd/ysoHf8q
Jxz/Kygd/ysoHf8rKB3/LCke/yglGf8tKh7/Kygc/yonG/8rKBz/Kygc/ywpHf8rKBz/Kicb/yon
G/8pJhr/Kygc/yonG/8sKR3/Kicb/ysoHP8rKBz/Kygc/ywpHf8pJhr/Kicb/ysoHP8qJxv/Kicb
/yonG/8qJxv/Kicb/ysoHP8rKBz/LCkd/yonG/8qJxv/LCkd/ysoHP8sKR3/Kygc/yonG/8qJxv/
Kygc/ysoHP8pJhr/Kicb/yonG/8rKBz/LCkd/ywpHf8pJhr/Kicb/ysoHP8rKBz/Kygc/ysoHP8q
Jxv/Kicb/ysoHP8qJxv/Kicb/ysoHP8pJhr/Kygc/ysoHP8rKBz/Kicb/ykmGv8rKBz/Kygc/yso
HP8rKBz/Kicb/ysoHP8rKBz/Kygc/ykmGv8pJhr/KSYa/ysoHP8pJhr/Kicb/yonG/8rKBz/Kygc
/ywpHf8qJxv/Kygc/yonG/8pJhr/Kygc/ykmGv8pJhr/LCkd/yonG/8pJhr/LCkd/ysoHP8qJxv/
Kicb/yonG/8pJhr/LCkd/ysoHP8tKh7/Kygc/yonG/8sKR3/Kygc/ywpHf8qJxv/Kygc/ykmGv8q
Jxv/Kicb/yonG/8qJxv/KSYa/ysoHP8pJhr/Kygc/ywpHf8qJxv/Kygc/yglGf8pJhr/Kygc/yon
G/8rKBz/Kygc/ywpHf8sKR3/Kicb/ywpHf8rKBz/KSYa/y0qHv8sKR3/LCkd/ykmGv8qJxv/Kicb
/yonG/8qJxv/Kicb/ysoHP8qJxv/Kygc/ysoHP8rKBz/Kygc/ysoHP8rKBz/LCkd/ysoHP8rKBz/
Kygc/ysoHP8sKR3/Kicb/yonG/8rKBz/Kygc/ywpHf8qJxv/LCkd/ykmGv8rKBz/Kygc/ysoHP8s
KR3/Kygc/yonG/8qJxv/Kygc/ysoHP8pJhr/Kicb/yonG/8rKBz/Kicb/yonG/8rKBz/KSYa/ygl
Gf8qJxv/Kicb/ysoHP8rKBz/Kygc/yonG/8tKh7/Kicb/ysoHP8pJhr/Kicb/yonG/8rKBz/Kygc
/ykmGv8qJxv/Kicb/y0qHv8qJxv/Kygc/ykmGv8sKR3/Kicb/ysoHP8sKR3/KSYa/ysoHP8pJhr/
Kygc/yonG/8rKBz/KSYa/yonG/8oJRn/LCkd/yonG/8rKBz/KSYa/ywpHf8sKR3/Kygc/ykmGv8q
Jxv/Kicb/ysoHP8rKBz/Kicb/yonG/8qJxv/LSoe/ywpHf8sKR3/LCkd/ywpHf8tKh7/LCkd/yon
G/8pJhr/KCUZ/ywpHf8qJxv/Kygc/ysoHP8sKR3/Kicb/ysoHP8pJhr/KSYa/ysoHP8rKBz/Kicb
/ysoHP8rKBz/Kygc/ywpHf8oJRn/LSof/ysoHP8qJxz/Kygd/ysoHP8sKR3/Kygc/yonG/8qJxv/
KSYa/ysoHP8qJxv/LCkd/yonG/8rKBz/Kygc/ysoHP8sKR3/KSYa/yonG/8rKBz/Kicb/yonG/8q
Jxv/Kicb/yonG/8rKBz/Kygc/ywpHf8qJxv/Kicb/ywpHf8rKBz/LCkd/ysoHP8qJxv/Kicb/yso
HP8rKBz/KCYa/yknG/8pJxv/Kigc/yspHf8rKR3/KCYa/yknG/8qKBz/Kigc/yooHP8qKBz/KScb
/yknG/8qKBz/KScb/yknG/8qKBz/KCYa/yooHP8qKBz/Kigc/yknG/8oJRr/Kigc/yooHP8qKBz/
Kigc/ykmG/8qJxz/Kicc/yonHP8oJRr/KCUb/yglG/8qJx3/KCUb/ykmHP8pJhz/Kicd/yonHf8r
KB7/KCYc/yknHf8oJhz/JyUb/yknHf8nJ'''
output_path = "output_image.png"
base64_to_image(base64_string, output_path)
