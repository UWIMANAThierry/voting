// Get api from backend
String url = "http://10.0.2.2:5000/"; // Run on emulator
// String url = "http://192.168.43.53:5000/"; // Run on device

var registerUserUrl = url + "api/signup";
var loginUserUrl = url + "api/login";
var candidateReg = url + "api/register_candidate";
var retrieveCandidateRoles = url + "api/candidate_roles";
var retrieveCandidateList = url + 'main/api/retrieve_candidate_list';
var retrieveCandidateListid = url + "main/api/retrieve_candidate_list_id/";
var retrieveCandidateCheckResutl = url + "main/api/retrieve_candidate_result";
var vorterurl = url + "/main/api/vote_section";
var getcandidateroles = url + '/main/api/display_candidate_roles';
