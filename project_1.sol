pragma solidity ^0.6.4;
pragma experimental ABIEncoderV2;

contract B_project {

    struct Provider {
        string ID; // 프로바이더의 ID 프로바이더의 ID를 여기다가 저장하는 게 맞나?, 
        string public_key;  // 프로바이더의 pub_key(이더리움 pub_key와는 다른 개념)
        string name; // 프로바이더의 name
        string base_url;   // 프로바이더 서버 end-point
        string credential_type; //이메일, 핸드폰 등등 인증 방식, 여러개의 인증 방식이 있으니, 구조체 혹은 배열로 선언해줘야되나?
    }

    struct CredentialResult
     {
        string Provider_ID; //프로바이더의 아이디 index 느낌!
        string public_key; //프로바이더 pub_key, 유저의 partial을 암호화하는 pub key
        string enc_Partial_Key; // Provider pub_key로 암호화 한 partial_key
        string signed_data; // 데이터가 제대로 
        string user_pub_key; //유저의 퍼블릭 key? 이더리움 address를 의미하는건지?
        string encrypted_payload; //인증한 방식, encrypted payload.
    }

    
    Provider[] public Providers_list; //등록된 프로바이더의 목록을 조회하기 위한 배열
    CredentialResult[] public Credentialresult_list; //하나의 유저가 본인이 등록한 credentialresult의 목록

    mapping(string => Provider[]) public regi_providers; //유저가 등록한 프로바이더의 목록을 조회하기 위한 mapping, key = 유저 pub_key
    mapping(string => Provider) public provider; //등록된 프로바이더의 목록을 프로바이더의 ID를 통해 조회하기 위한 mapping, key = 프로바이더 ID
    mapping(string => CredentialResult[]) public credentialresults; //등록된 프로바이더의 목록을 프로바이더의 ID를 통해 조회하기 위한 mapping, key = pub_key


    //프로바이더가 자신을 프로바이더로 등록하는 함수, 웹앱에서만 호출 가능.
    function registerProv(string memory ID, string memory public_key, string  memory name, string  memory base_url, string memory credential_type) public {
        Providers_list.push(Provider(ID, public_key, name, base_url, credential_type)); //생성된 구조체 배열에 새로운 프로바이더 담기
        //매핑도 추가해줘야 될듯
        provider[ID] = Provider(ID, public_key, name, base_url, credential_type);
    }

    //시스템에 등록한 프로바이더 전체의 이름과 base_url을 return해주는 함수, 서버에서 콜, 
    function getProvList() public returns (string[] memory, string[] memory, string[] memory, string[] memory, string[] memory) {
        string[] memory provID = new string[](Providers_list.length);
        string[] memory provPubkey = new string[](Providers_list.length);
        string[] memory provname = new string[](Providers_list.length);
        string[] memory provbase_url = new string[](Providers_list.length);
        string[] memory provcredential_type = new string[](Providers_list.length);
               
        for(uint i = 0; i <= Providers_list.length; i++) {
             provID[i] = Providers_list[i].ID; //ID 배열
             provPubkey[i] = Providers_list[i].public_key; //pubkey 배열
             provname[i] = Providers_list[i].name; //이름 배열
             provbase_url[i] = Providers_list[i].base_url;
             provcredential_type[i] = Providers_list[i].credential_type;
        }
        return (provID, provPubkey, provname, provbase_url, provcredential_type);
    }

        //시스템에 등록한 프로바이더 전체의 이름과 base_url을 return해주는 함수, 서버에서 콜
    function getProvList2(uint idx) public returns (Provider[] memory) {
            return (Providers_list);
    }

   //유저의 부분키를 등록하는 함수
    function registerPK(string memory ID, string memory public_key, string memory enc_partial_Key, string memory signed_data, string memory user_pub_key, string memory encrypted_payload) public {
        CredentialResult memory result = CredentialResult(ID, public_key, user_pub_key, enc_partial_Key, signed_data, encrypted_payload);
        //Credentialresult_list.push(result);
        credentialresults[user_pub_key].push(result);

        regi_providers[user_pub_key].push(provider[ID]);
    }
    
    //유저가 본인의 partial key를 맡긴 프로바이더의 목록을 return 해주는 함수 from credential result
    function getProvListByUserPK(string memory user_pub_key) public returns (string[] memory, string[] memory, string[] memory) {

        string[] memory provID = new string[](Providers_list.length);
        string[] memory provPubkey = new string[](Providers_list.length);
        string[] memory provcredential_type = new string[](Providers_list.length);

        for(uint i = 0; i <= Providers_list.length; i++) {
            provID[i] = credentialresults[user_pub_key][i].Provider_ID;
            provPubkey[i] = credentialresults[user_pub_key][i].public_key;
            provcredential_type[i] = credentialresults[user_pub_key][i].encrypted_payload;
        }
        return (provID, provPubkey, provcredential_type);
    }

    //유저가 본인의 partial key를 맡긴 프로바이더의 목록을 return 해주는 함수 from provider 구조체
    function get_RegiProvList(string memory user_pub_key) public returns (Provider[] memory) {
        Provider[] memory temp_list = new Provider[](regi_providers[user_pub_key].length);
        for(uint i = 0; i <= regi_providers[user_pub_key].length; i++) {
           temp_list[i] = regi_providers[user_pub_key][i];
        }

        return temp_list;

    }

    //프로바이더의 상세정보를 얻어오는 함수, 위의 함수에서 다 리턴해주니까 필요없겠는데
    // function getProvInfo(string ID) public returns (string, string, string, string, string) {
    //     return (provider[ID].name, provider[ID].public_key, provider[ID].name, provider[ID].base_url, provider[ID].credential);
    // }

 

    //유저의 부분키를 복구하는 함수
    //function GetCredentialData(string provider_id,) public {

    //}

    //탈퇴하고자하는 프로바이더 삭제하는 함수도 필요할듯?

}