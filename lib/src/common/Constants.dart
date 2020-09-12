class Constants {

      static const TXT_APP_TITLE = 'Community Tracker';

      //IMAGES
      static const IMG_ICPEP = 'assets/images/icpep.png';
      static const IMG_TRACKER = 'assets/images/ct_logo.png';
      static const IMG_ARROW = 'assets/images/direction.png';
      static const IMG_DEFAULT_PHOTO = 'assets/images/default_photo.png';
      //LABELS
      static const TXT_BUTTON_LOGIN  = 'LOGIN';
      static const TXT_BUTTON_LOGOUT = 'LOGOUT';
      static const TXT_BUTTON_REGISTER = 'REGISTER NOW';
      static const TXT_LABEL_NO_ACCOUNT = 'Don\'t have an account ?';
      static const TXT_LABEL_REGISTER = 'SIGN UP';
      static const TXT_LABEL_USERNAME = 'E-Mail Address';
      static const TXT_LABEL_PASSWORD = 'Password';
      static const TXT_LABEL_NEW_PASSWORD = 'New Password';
      static const TXT_LABEL_TOKEN = 'Token';
      static const TXT_LABEL_FORGOT_PASSWORD = 'Forgot Password ?';
      static const TXT_LABEL_GOT_ACCOUNT = 'Already have an account ?';
      static const TXT_LABEL_CONFIRM_PASSWORD = 'Confirm Password';

      // MESSAGES
      static const MSG_ERROR_USERNAME = 'Please enter your eMail Address!';
      static const MSG_ERROR_PASSWORD = 'Please enter a  password!';
      static const MSG_SUCCESS_NEW_ACCOUNT = "Account Successfully Created. Please login with your account";
      static const MSG_ERROR_PASSWORD_FMT = 'Please enter a minimum 8 character password';
      static const MSG_ERROR_MISMATCH = 'Password does not match';
      static const MSG_ERROR_USERNAME_FMT = 'Invalid Username format';

      //URLS
      //static const API_URL_LOGIN = 'https://newcodeninja.com/webapp/login.php';
      //static const API_URL_SIGN_UP = 'https://newcodeninja.com/webapp/ct_signup.php';
      static const API_URL_PRIVACY = 'http://icpep-appli-sea1jyekuzc0-14925811.ap-southeast-1.elb.amazonaws.com/static/privacy.html';
      static const API_URL_TERMS = 'http://icpep-appli-sea1jyekuzc0-14925811.ap-southeast-1.elb.amazonaws.com/static/terms.html';
      static const API_URL_ABOUT = 'https://icpepsingapore.com/about-us/';
      static const API_URL_CONTACT = 'https://icpepsingapore.com/contact/';
      static const API_URL_LOGIN = 'http://icpep-appli-sea1jyekuzc0-14925811.ap-southeast-1.elb.amazonaws.com/api/users/login';
      static const API_URL_SIGN_UP = 'http://icpep-appli-sea1jyekuzc0-14925811.ap-southeast-1.elb.amazonaws.com/api/users/signup';
      static const API_URL_LOG = 'http://icpep-appli-sea1jyekuzc0-14925811.ap-southeast-1.elb.amazonaws.com/api/track/log';
      static const API_URL_FACEBOOK_TOKEN = 'https://graph.facebook.com/v2.3/me?fields=email,id,first_name,last_name,middle_name,name,name_format,picture.width(500).height(500),short_name&access_token=';
      static const API_URL_DEFAULT_PHOTO  = 'https://newcodeninja.com/default_photo.png';
      static const API_URL_MARKERS = 'https://newcodeninja.com/webapp/markers.php';
      static const API_URL_REQUEST_RESET = 'http://icpep-appli-sea1jyekuzc0-14925811.ap-southeast-1.elb.amazonaws.com/api/users/reset-password/';
      static const API_URL_CONFIRM_RESET = 'http://icpep-appli-sea1jyekuzc0-14925811.ap-southeast-1.elb.amazonaws.com/api/users/reset-password/confirm/';
}