function v = computeClassQueen()
%============================================
% Computes Class vector
%============================================

mydir = '../Self-avoiding/CyclesQueen';
ids = {'5842fdc0-c93b-4918-8e0a-9d07cdc2ad49','44657e0e-eeef-4b55-9c27-c9a896c95344','4f75a5f7-b4c4-46c0-930b-76bc43a41b06','3951060e-763e-4e3f-9403-fc09e63af90e','befc5cc2-25a7-479f-83be-629adf542229','ca57be8c-73fd-48fc-a2ec-dda75df1a463','1b95c224-bc2f-4f46-a32c-19004d06d8b5','bb254307-72bc-4509-b411-169b42476ead','08f1b1aa-90d2-48b9-903c-eab50180c6c8','1e27c059-adac-4067-a189-128b6d2c8360','cba31046-9e03-4bc7-a0d1-d9e246eb771f','ee82948e-ad5e-4f12-830e-f9666f92a05d','21fbe009-6876-4488-a4a2-b7d4c399c2af','dd9188e1-b7f0-4538-bd61-8b7559546dd1','bdeb4892-649d-4e21-8c5e-059dc2ce3a22','cd45626c-4873-42f9-a184-3a5d801c3991','64c1c51c-c7b2-4039-b6f8-fb4f79e05571','c2c60c37-dd97-4057-b40f-81138abacc36','ef2b5a59-1a18-4b6e-8701-7a6f42f93692','a3369a31-fcff-4168-840c-aec625d17151','97c82695-a223-42b8-8e75-702fc4bebae6','3eff9751-8840-4f94-a65a-5ff8440021a2','3241bf67-3f58-4cd5-ad06-7282430bec6d','752c8423-1d54-4af5-ba0c-d3a7dc2dba06','2a72fc8b-7e3b-4999-8cc2-1eaf4b106b2b','a457f297-5dd2-4965-9a45-467ad885ea23','93d07384-5932-4dfc-9398-22b1f1bc1ccb','9d4f1065-373f-44c0-ab80-716b5ed9749c','5ed4457f-af91-459d-9d14-34942db0f438','a17bcdb2-ba87-402c-bc27-7919edf644f6','0b7ef6b5-d63d-48a4-9f16-59f167862052','1a529df7-a364-4626-b0df-60c679752bd3','afd49214-8c8b-4ae8-9b55-3e35dac5a8f0','5dd8ae40-dc67-4df0-ba81-4e13f8f22a95','e35c2102-72e0-40c8-8f14-164a0c722014','76a8180b-3b59-4731-8b92-4c3652acd806','0c8b46ad-29ee-4a81-bad1-7ca41fdf9208','8edb941b-79f8-4a32-bdfa-1663f485f65e','4879f868-1758-4612-9a88-a4f4fa146ca7','f1a75b94-a9a7-4397-babc-fc56d31e3e5e'};
classes = [1:20 1:20];

mylist = ls(mydir);
numItems = (length(mylist)/41);
n = 0;
cbegin = 1;
cend = 0;
v = [];

for i=1:numItems 
	cend = cbegin + 39;
	myfile = mylist(cbegin:(cend-4))
	cbegin = cend + 2;
	
	%=== We verify the real class of the song ===
	for j=1:length(ids)
		if strcmp(ids{j},myfile)
			v(i) = classes(j);
		end
	end	
end
