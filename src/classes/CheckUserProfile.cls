public class CheckUserProfile {
    public static void dependOnProfile(){
        Profile userProfile=[
            SELECT Id,Name
            FROM Profile
            Where Id= :UserInfo.getProfileId()
        ];
    }

}