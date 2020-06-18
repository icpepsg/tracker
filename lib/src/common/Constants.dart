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
      static const TXT_LABEL_REGISTER = 'Register';
      static const TXT_LABEL_USERNAME = 'Username or E-Mail Address';
      static const TXT_LABEL_PASSWORD = 'Password';
      static const TXT_LABEL_FORGOT_PASSWORD = 'Forgot Password ?';
      static const TXT_LABEL_GOT_ACCOUNT = 'Already have an account ?';
      static const TXT_LABEL_CONFIRM_PASSWORD = 'Confirm Password';

      // MESSAGES
      static const MSG_ERROR_USERNAME = 'Please enter a Username or Email Address!';
      static const MSG_ERROR_PASSWORD = 'Please enter a  password!';
      static const MSG_SUCCESS_NEW_ACCOUNT = "Account Successfully Created. Please login with your account";
      static const MSG_ERROR_PASSWORD_FMT = 'Please enter a minimum 8 character password';
      static const MSG_ERROR_MISMATCH = 'Password does not match';

      //URLS
      //static const API_URL_LOGIN = 'http://kelvinco.ml/webapp/login.php';
      //static const API_URL_SIGN_UP = 'http://kelvinco.ml/webapp/ct_signup.php';
      static const API_URL_LOGIN = 'http://ec2-54-179-155-193.ap-southeast-1.compute.amazonaws.com/api/users/login';
      static const API_URL_SIGN_UP = 'http://ec2-54-179-155-193.ap-southeast-1.compute.amazonaws.com/api/users/signup';
      static const API_URL_FACEBOOK_TOKEN = 'https://graph.facebook.com/v2.3/me?fields=email,id,first_name,last_name,middle_name,name,name_format,picture.width(500).height(500),short_name&access_token=';
      static const API_URL_DEFAULT_PHOTO  = 'http://kelvinco.ml/default_photo.png';
}