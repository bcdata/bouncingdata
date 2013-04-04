<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Bouncing Data | User Login</title>
  <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bouncingdata/login.css" />" />
  <link type="text/css" href="<c:url value="/resources/css/jquery-ui/smoothness/jquery-ui-1.8.20.custom.css" />" rel="stylesheet" />
  <script type="text/javascript" src="<c:url value="/resources/js/jquery/jquery-1.7.2.min.js" />"></script>
  <script type="text/javascript" src="<c:url value="/resources/js/jquery/jquery-ui-1.8.20.custom.min.js" />"></script>
  <script type="text/javascript" src="<c:url value="/resources/js/bouncingdata/login.js" />"></script>
  <style>
    .error-block, .message-block-error {
      color: #ff0000;
      border: 0 none;
      padding: 8px;
    }
    .message-block {
      color: blue;
      border: 0 none;
      padding: 8px;  
    }
  </style>
</head>
<body onload='document.f.j_username.focus();'>
  <div class="page" id="page">
    <div class="top-content">
      <div class="logo">
      
      </div>
      <div class="title">
        <h1>Bouncing Data</h1>
      </div>
      <div class="top-horizontal-rule"></div>
    </div>
    <div class="login-main-container">
      <div class="login-tabs" id="login-tabs">
        <ul>
          <li><a href="#login">Login</a></li>
          <li><a href="#signup">Sign up</a></li>
        </ul>
        <div id="login">
          <h4 style="margin-bottom: 2px;">Login to your account</h4>
          <div class="message">
            <c:if test="${not empty error}">
              <div class="error-block" id="error-msg">
                Your login attempt was not successful, try again.
              </div>
            </c:if>
          </div>
          <div class="login-form">
            <form name='f' action="<c:url value='/auth/security_check' />" method='post'> 
                <label>Username</label>
                <input class="input-field" type='text' name='j_username' id='username' maxlength="40"></input>
                <label>Password</label>
                <input class="input-field" type='password' name='j_password' id='password' maxlength="100"></input>
                <div class="login-actions">
                  <input type="submit" name="submit" value="Login" onclick="if ($('#username').val().length <= 0 || $('#password').val().length <= 0) return false; else return true;" />
                  <a href="#">Forgot your password?</a>
                </div>            
              <div class="clear"></div>
            </form>
          </div>
        </div>
        <div id="signup">
          <h4>Register new account</h4>
          <div class="message">
            <c:if test="${not empty regResult}">
              <div class="message-block" id="register-msg">
                <span>${regResult.message }</span>
                <c:if test="${regResult.statusCode < 0}">
                  <script type="text/javascript">
                  $(function() {
                    $('#reg-username').val('${regResult.username}');
                  	$('#reg-email').val('${regResult.email}');
                  	$('#register-msg').removeClass('message-block');
                  	$('#register-msg').addClass('message-block-error');
                  });
                  </script>
                </c:if>
              </div>
            </c:if>
          </div>
          <div class="register-form">
            <form action="<c:url value='/auth/register' />" method="post"> 
              <div>
                <label for='register-username'>Username</label>
                <input class="input-field" type='text' name='username' id='reg-username' maxlength="40"></input>
              </div>
              <div>  
                <label for='reg-password'>Password</label>
                <input class="input-field" type='password' name='password' id='reg-password' maxlength="100"></input>
              </div>
              <div>  
                <label for='reg-password2'>Re-type Password</label>
                <input class="input-field" type='password' name='password2' id='reg-password2' maxlength="100"></input>
              </div>
              <div>
                <label for='reg-email'>Email</label>
                <input class="input-field" type='text' name='email' id='reg-email' maxlength="100"></input>
              </div>
              
              <div class="reg-actions">
                <input type="submit" name="submit" value="Submit" onclick="if ($('#reg-username').val().length <= 0 || $('#reg-password').val().length <= 0 || $('#reg-email').val().length <= 0) return false; else return true;" />
                <input type="reset" name="reset" value="Reset"></input>
              </div>            
              <div class="clear"></div>
            </form>
          </div>
        </div>
        <div id="forgot-password" style="display: none;">
          <h4>Reset your password</h4>
          <div class="message">
          
          </div>
          <div class="forgot-password-form">
            <form action="" method="post">
              <div>
                <label for='user-email'>Please enter your registered email:</label>
                <input class="input-field" type='text' name='user-email' id='user-email' maxlength="100"></input>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <div class="footer">
      <div class="footer-content">
        <a href="#" class="footer-link">Term of Service</a>
        <a href="#" class="footer-link">Privacy Policy</a>
        <a href="#" class="footer-link">Help</a>
        <div class="footer-right">
          <span>Copyright &copy;2012 bouncingdata.com. All rights reserved.</span>
        </div>
      </div>
    </div>
  </div>  
</body>
</html>