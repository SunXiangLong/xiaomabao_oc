//////////////////////////////////////////////////////////////////////////
//                                                                      //
// This is a generated file. You can view the original                  //
// source in your browser if your browser supports source maps.         //
// Source maps are supported by all recent versions of Chrome, Safari,  //
// and Firefox, and by Internet Explorer 11.                            //
//                                                                      //
//////////////////////////////////////////////////////////////////////////


(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var Accounts = Package['accounts-base'].Accounts;
var AccountsClient = Package['accounts-base'].AccountsClient;
var SRP = Package.srp.SRP;
var SHA256 = Package.sha.SHA256;
var EJSON = Package.ejson.EJSON;
var DDP = Package['ddp-client'].DDP;
var check = Package.check.check;
var Match = Package.check.Match;
var _ = Package.underscore._;
var ECMAScript = Package.ecmascript.ECMAScript;
var babelHelpers = Package['babel-runtime'].babelHelpers;
var Symbol = Package['ecmascript-runtime'].Symbol;
var Map = Package['ecmascript-runtime'].Map;
var Set = Package['ecmascript-runtime'].Set;
var Promise = Package.promise.Promise;

(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
// packages/accounts-password/password_client.js                                                              //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                              //
// Attempt to log in with a password.                                                                         //
//                                                                                                            //
// @param selector {String|Object} One of the following:                                                      //
//   - {username: (username)}                                                                                 //
//   - {email: (email)}                                                                                       //
//   - a string which may be a username or email, depending on whether                                        //
//     it contains "@".                                                                                       //
// @param password {String}                                                                                   //
// @param callback {Function(error|undefined)}                                                                //
                                                                                                              //
/**                                                                                                           //
 * @summary Log the user in with a password.                                                                  //
 * @locus Client                                                                                              //
 * @param {Object | String} user                                                                              //
 *   Either a string interpreted as a username or an email; or an object with a                               //
 *   single key: `email`, `username` or `id`. Username or email match in a case                               //
 *   insensitive manner.                                                                                      //
 * @param {String} password The user's password.                                                              //
 * @param {Function} [callback] Optional callback.                                                            //
 *   Called with no arguments on success, or with a single `Error` argument                                   //
 *   on failure.                                                                                              //
 */                                                                                                           //
Meteor.loginWithPassword = function (selector, password, callback) {                                          // 23
  if (typeof selector === 'string') if (selector.indexOf('@') === -1) selector = { username: selector };else selector = { email: selector };
                                                                                                              //
  Accounts.callLoginMethod({                                                                                  // 30
    methodArguments: [{                                                                                       // 31
      user: selector,                                                                                         // 32
      password: Accounts._hashPassword(password)                                                              // 33
    }],                                                                                                       //
    userCallback: function (error, result) {                                                                  // 35
      if (error && error.error === 400 && error.reason === 'old password format') {                           // 36
        // The "reason" string should match the error thrown in the                                           //
        // password login handler in password_server.js.                                                      //
                                                                                                              //
        // XXX COMPAT WITH 0.8.1.3                                                                            //
        // If this user's last login was with a previous version of                                           //
        // Meteor that used SRP, then the server throws this error to                                         //
        // indicate that we should try again. The error includes the                                          //
        // user's SRP identity. We provide a value derived from the                                           //
        // identity and the password to prove to the server that we know                                      //
        // the password without requiring a full SRP flow, as well as                                         //
        // SHA256(password), which the server bcrypts and stores in                                           //
        // place of the old SRP information for this user.                                                    //
        srpUpgradePath({                                                                                      // 50
          upgradeError: error,                                                                                // 51
          userSelector: selector,                                                                             // 52
          plaintextPassword: password                                                                         // 53
        }, callback);                                                                                         //
      } else if (error) {                                                                                     //
        callback && callback(error);                                                                          // 57
      } else {                                                                                                //
        callback && callback();                                                                               // 59
      }                                                                                                       //
    }                                                                                                         //
  });                                                                                                         //
};                                                                                                            //
                                                                                                              //
Accounts._hashPassword = function (password) {                                                                // 65
  return {                                                                                                    // 66
    digest: SHA256(password),                                                                                 // 67
    algorithm: "sha-256"                                                                                      // 68
  };                                                                                                          //
};                                                                                                            //
                                                                                                              //
// XXX COMPAT WITH 0.8.1.3                                                                                    //
// The server requested an upgrade from the old SRP password format,                                          //
// so supply the needed SRP identity to login. Options:                                                       //
//   - upgradeError: the error object that the server returned to tell                                        //
//     us to upgrade from SRP to bcrypt.                                                                      //
//   - userSelector: selector to retrieve the user object                                                     //
//   - plaintextPassword: the password as a string                                                            //
var srpUpgradePath = function (options, callback) {                                                           // 79
  var details;                                                                                                // 80
  try {                                                                                                       // 81
    details = EJSON.parse(options.upgradeError.details);                                                      // 82
  } catch (e) {}                                                                                              //
  if (!(details && details.format === 'srp')) {                                                               // 84
    callback && callback(new Meteor.Error(400, "Password is old. Please reset your " + "password."));         // 85
  } else {                                                                                                    //
    Accounts.callLoginMethod({                                                                                // 89
      methodArguments: [{                                                                                     // 90
        user: options.userSelector,                                                                           // 91
        srp: SHA256(details.identity + ":" + options.plaintextPassword),                                      // 92
        password: Accounts._hashPassword(options.plaintextPassword)                                           // 93
      }],                                                                                                     //
      userCallback: callback                                                                                  // 95
    });                                                                                                       //
  }                                                                                                           //
};                                                                                                            //
                                                                                                              //
// Attempt to log in as a new user.                                                                           //
                                                                                                              //
/**                                                                                                           //
 * @summary Create a new user.                                                                                //
 * @locus Anywhere                                                                                            //
 * @param {Object} options                                                                                    //
 * @param {String} options.username A unique name for this user.                                              //
 * @param {String} options.email The user's email address.                                                    //
 * @param {String} options.password The user's password. This is __not__ sent in plain text over the wire.    //
 * @param {Object} options.profile The user's profile, typically including the `name` field.                  //
 * @param {Function} [callback] Client only, optional callback. Called with no arguments on success, or with a single `Error` argument on failure.
 */                                                                                                           //
Accounts.createUser = function (options, callback) {                                                          // 113
  options = _.clone(options); // we'll be modifying options                                                   // 114
                                                                                                              //
  if (typeof options.password !== 'string') throw new Error("options.password must be a string");             // 116
  if (!options.password) {                                                                                    // 118
    callback(new Meteor.Error(400, "Password may not be empty"));                                             // 119
    return;                                                                                                   // 120
  }                                                                                                           //
                                                                                                              //
  // Replace password with the hashed password.                                                               //
  options.password = Accounts._hashPassword(options.password);                                                // 124
                                                                                                              //
  Accounts.callLoginMethod({                                                                                  // 126
    methodName: 'createUser',                                                                                 // 127
    methodArguments: [options],                                                                               // 128
    userCallback: callback                                                                                    // 129
  });                                                                                                         //
};                                                                                                            //
                                                                                                              //
// Change password. Must be logged in.                                                                        //
//                                                                                                            //
// @param oldPassword {String|null} By default servers no longer allow                                        //
//   changing password without the old password, but they could so we                                         //
//   support passing no password to the server and letting it decide.                                         //
// @param newPassword {String}                                                                                //
// @param callback {Function(error|undefined)}                                                                //
                                                                                                              //
/**                                                                                                           //
 * @summary Change the current user's password. Must be logged in.                                            //
 * @locus Client                                                                                              //
 * @param {String} oldPassword The user's current password. This is __not__ sent in plain text over the wire.
 * @param {String} newPassword A new password for the user. This is __not__ sent in plain text over the wire.
 * @param {Function} [callback] Optional callback. Called with no arguments on success, or with a single `Error` argument on failure.
 */                                                                                                           //
Accounts.changePassword = function (oldPassword, newPassword, callback) {                                     // 148
  if (!Meteor.user()) {                                                                                       // 149
    callback && callback(new Error("Must be logged in to change password."));                                 // 150
    return;                                                                                                   // 151
  }                                                                                                           //
                                                                                                              //
  check(newPassword, String);                                                                                 // 154
  if (!newPassword) {                                                                                         // 155
    callback(new Meteor.Error(400, "Password may not be empty"));                                             // 156
    return;                                                                                                   // 157
  }                                                                                                           //
                                                                                                              //
  Accounts.connection.apply('changePassword', [oldPassword ? Accounts._hashPassword(oldPassword) : null, Accounts._hashPassword(newPassword)], function (error, result) {
    if (error || !result) {                                                                                   // 165
      if (error && error.error === 400 && error.reason === 'old password format') {                           // 166
        // XXX COMPAT WITH 0.8.1.3                                                                            //
        // The server is telling us to upgrade from SRP to bcrypt, as                                         //
        // in Meteor.loginWithPassword.                                                                       //
        srpUpgradePath({                                                                                      // 171
          upgradeError: error,                                                                                // 172
          userSelector: { id: Meteor.userId() },                                                              // 173
          plaintextPassword: oldPassword                                                                      // 174
        }, function (err) {                                                                                   //
          if (err) {                                                                                          // 176
            callback && callback(err);                                                                        // 177
          } else {                                                                                            //
            // Now that we've successfully migrated from srp to                                               //
            // bcrypt, try changing the password again.                                                       //
            Accounts.changePassword(oldPassword, newPassword, callback);                                      // 181
          }                                                                                                   //
        });                                                                                                   //
      } else {                                                                                                //
        // A normal error, not an error telling us to upgrade to bcrypt                                       //
        callback && callback(error || new Error("No result from changePassword."));                           // 186
      }                                                                                                       //
    } else {                                                                                                  //
      callback && callback();                                                                                 // 190
    }                                                                                                         //
  });                                                                                                         //
};                                                                                                            //
                                                                                                              //
// Sends an email to a user with a link that can be used to reset                                             //
// their password                                                                                             //
//                                                                                                            //
// @param options {Object}                                                                                    //
//   - email: (email)                                                                                         //
// @param callback (optional) {Function(error|undefined)}                                                     //
                                                                                                              //
/**                                                                                                           //
 * @summary Request a forgot password email.                                                                  //
 * @locus Client                                                                                              //
 * @param {Object} options                                                                                    //
 * @param {String} options.email The email address to send a password reset link.                             //
 * @param {Function} [callback] Optional callback. Called with no arguments on success, or with a single `Error` argument on failure.
 */                                                                                                           //
Accounts.forgotPassword = function (options, callback) {                                                      // 210
  if (!options.email) throw new Error("Must pass options.email");                                             // 211
  Accounts.connection.call("forgotPassword", options, callback);                                              // 213
};                                                                                                            //
                                                                                                              //
// Resets a password based on a token originally created by                                                   //
// Accounts.forgotPassword, and then logs in the matching user.                                               //
//                                                                                                            //
// @param token {String}                                                                                      //
// @param newPassword {String}                                                                                //
// @param callback (optional) {Function(error|undefined)}                                                     //
                                                                                                              //
/**                                                                                                           //
 * @summary Reset the password for a user using a token received in email. Logs the user in afterwards.       //
 * @locus Client                                                                                              //
 * @param {String} token The token retrieved from the reset password URL.                                     //
 * @param {String} newPassword A new password for the user. This is __not__ sent in plain text over the wire.
 * @param {Function} [callback] Optional callback. Called with no arguments on success, or with a single `Error` argument on failure.
 */                                                                                                           //
Accounts.resetPassword = function (token, newPassword, callback) {                                            // 230
  check(token, String);                                                                                       // 231
  check(newPassword, String);                                                                                 // 232
                                                                                                              //
  if (!newPassword) {                                                                                         // 234
    callback(new Meteor.Error(400, "Password may not be empty"));                                             // 235
    return;                                                                                                   // 236
  }                                                                                                           //
                                                                                                              //
  Accounts.callLoginMethod({                                                                                  // 239
    methodName: 'resetPassword',                                                                              // 240
    methodArguments: [token, Accounts._hashPassword(newPassword)],                                            // 241
    userCallback: callback });                                                                                // 242
};                                                                                                            //
                                                                                                              //
// Verifies a user's email address based on a token originally                                                //
// created by Accounts.sendVerificationEmail                                                                  //
//                                                                                                            //
// @param token {String}                                                                                      //
// @param callback (optional) {Function(error|undefined)}                                                     //
                                                                                                              //
/**                                                                                                           //
 * @summary Marks the user's email address as verified. Logs the user in afterwards.                          //
 * @locus Client                                                                                              //
 * @param {String} token The token retrieved from the verification URL.                                       //
 * @param {Function} [callback] Optional callback. Called with no arguments on success, or with a single `Error` argument on failure.
 */                                                                                                           //
Accounts.verifyEmail = function (token, callback) {                                                           // 257
  if (!token) throw new Error("Need to pass token");                                                          // 258
                                                                                                              //
  Accounts.callLoginMethod({                                                                                  // 261
    methodName: 'verifyEmail',                                                                                // 262
    methodArguments: [token],                                                                                 // 263
    userCallback: callback });                                                                                // 264
};                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['accounts-password'] = {};

})();
