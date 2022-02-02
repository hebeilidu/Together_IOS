/* Amplify Params - DO NOT EDIT
	AUTH_TOGETHER2_USERPOOLID
	ENV
	REGION
Amplify Params - DO NOT EDIT */
const aws = require('aws-sdk');
const cognitoidentityserviceprovider = new aws.CognitoIdentityServiceProvider({
    apiVersion: '2016-04-18',
  });
  
  exports.handler = async (event) => {
      // TODO implement
      
      const getUserParams = {
          "Username": event.queryStringParameters.username,
          "UserPoolId": "us-east-2_dddkcOxgu"
      };
      let response;
      let firstName;
      let lastName;
      let gender;
      let nickName;
      
      try {
          const item = await cognitoidentityserviceprovider.adminGetUser(getUserParams).promise();
          const result = JSON.parse(JSON.stringify(item));
          const attributes = JSON.parse(JSON.stringify(result.UserAttributes));
          attributes.forEach(attribute => {
              switch (attribute.Name) {
                  case 'gender':
                      gender = attribute.Value;
                      break;
                  case 'nickname':
                      nickName = attribute.Value;
                      break;
                  case 'given_name':
                      firstName = attribute.Value;
                      break;
                  case 'family_name':
                      lastName = attribute.Value;
                      break;
              }
          });
          response = {
              "statusCode": 200,
          //  Uncomment below to enable CORS requests
          //  headers: {
          //      "Access-Control-Allow-Origin": "*",
          //      "Access-Control-Allow-Headers": "*"
          //  }, 
              "body": JSON.stringify({
                  firstName: firstName,
                  lastName: lastName,
                  gender: gender,
                  nickName: nickName
              })
          };
      } catch (e) {
          response = {
              "statusCode": 400
          };
      }
      return response;
  };