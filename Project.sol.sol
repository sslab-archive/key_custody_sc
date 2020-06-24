pragma solidity ^0.5.10;

contract B_project {

    struct Provider {
        string ID; // 프로바이더의 ID 프로바이더의 ID를 여기다가 저장하는 건
        string public_key;  // 프로바이더의 pub_key(이더리움 pub_key와는 다른 개념)
        string name; // 프로바이더의 name
        string base_url;   // ?
        string credential; //이메일, 핸드폰 등등 인증 방식, 여러개의 인증 방식이 있으니, 구조체 혹은 배열로 선언해줘야되나?
    }

    struct CredentialResult
     {
        string Provider_ID; //프로바이더의 아이디
        string public_key; //프로바이더 pub_key
        string Partial_Key; // Provider pub_key로 암호화 한 partial_key
        string signed_data; //?
        string user_pub_key; //유저의 퍼블릭 key
        string credential; //인증한 방식
    }

    address public provider;
    Provider[] public Providers_list; //등록된 프로바이더의 목록을 조회하기 위한 배열
    CredentialResult[] public Credentialresult_list; //하나의 유저가 본인이 등록한 credentialresult의 목록

    mapping(string => Provider[]) public regi_providers; //유저가 등록한 프로바이더의 목록을 조회하기 위한 mapping key = 유저 ID
    mapping(string => Provider) public provider; //등록된 프로바이더의 목록을 프로바이더의 ID를 통해 조회하기 위한 mapping key = 프로바이더 ID
    mapping(string => CredentialResult[]) public credentialresults; //등록된 프로바이더의 목록을 프로바이더의 ID를 통해 조회하기 위한 mapping 유저의 key = pub_key

    

        modifier onlyBy(address _account)
    {
        require(
            msg.sender == _account,
            "Sender not authorized."
        );
        _;
    }

    //프로바이더가 자신을 프로바이더로 등록하는 함수, 웹앱에서만 호출 가능.
    function registerProv(string ID, string public_key, string name, string base_url, string credential) public {
        Providers_list.push(Provider(ID, public_key, name, base_url, credential)); //생성된 구조체 배열에 새로운 프로바이더 담기
        //매핑도 추가해줘야 될듯

    }

    //시스템에 등록한 프로바이더 전체의 이름과 base_url을 return해주는 함수, 서버에서 콜
    function getProvList(uint idx) public returns (string[]) {
        string[] temp;

        for(uint i = 0; i <= Providers_list.length; i++) {
             temp[i] = Providers_list[i].name;
        }
        return temp;
    }

        //시스템에 등록한 프로바이더 전체의 이름과 base_url을 return해주는 함수, 서버에서 콜
    function getProvList2(uint idx) public returns (string) {
            return Providers_list[idx].name;
    }

   //유저의 부분키를 등록하는 함수
    function registerPK(string ID, struct credential_result) public {

    }
    
    //유저가 본인의 partial key를 맡긴 프로바이더의 목록을 return 해주는 함수
    function getProvListByUserPK(string ID) public view returns (string) {

        return providers[ID];

    }

    //프로바이더의 상세정보를 얻어오는 함수
    function getProvInfo(string ID) public returns (string, string, string, string, string) {
        return (provider[ID].name, provider[ID].public_key, provider[ID].name, provider[ID].base_url, provider[ID].credential);
    }

 

    //유저의 부분키를 복구하는 함수
    function GetCredentialData(string provider_id, struct credential_result) public {

    }

    //탈퇴하고자하는 프로바이더 삭제하는 함수도 필요할듯?

}