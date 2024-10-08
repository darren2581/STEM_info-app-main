import '../post/post_manager.dart';

class PostService {
  final PostManager _postManager;

  PostService(this._postManager);

  void addPosts() {
    _postManager.addPost(
      'Curtin Malaysia programme head masters cutting-edge automation at Ultech Engineering workshop',
      Post(
        title: 'Curtin Malaysia programme head masters cutting-edge automation at Ultech Engineering workshop',
        date: '2023-06-30',
        url: 'https://news.curtin.edu.my/news/curtin-malaysia-programme-head-masters-cutting-edge-automation-at-ultech-engineering-workshop/?sfnsn=mo&fbclid=IwZXh0bgNhZW0CMTEAAR3b5sgL4_L57t04J3VPqhV6U3vCjeLSS2lStNrpWra4a78foodjKXpamwY_aem_8sBdY8OPnXwOyRpMJV9tIQ',
        image: 'assets/image/Basic_Siemens_PLC_and_HMI_training_workshop.jpg',
      ),
    );
    _postManager.addPost(
      'Cyber Guard Bootcamp',
      Post(
        title: 'Cyber Guard Bootcamp',
        date: '2023-06-26',
        url: 'https://www.facebook.com/IEEE.CurtinMalaysia/posts/pfbid0V2yX2MKToh2HpKhZVNHdUGytj3adSp4Gas9dgayzGfNXDuaYSDAPy7PbZ5wYEc15l',
        image: 'assets/image/Cyber_Guard_Bootcamp.jpg',
      ),
    );
    _postManager.addPost(
      'Basic Siemens PLC and HMI training workshop',
      Post(
        title: 'Basic Siemens PLC and HMI training workshop',
        date: '2023-06-22',
        url: 'https://www.facebook.com/IEEE.CurtinMalaysia/posts/pfbid02shkj93g321ogQr8d6gt5dPVSkzUnmnBB2bGEMpE9cDHA9KEDAeikYFJHEN4P9Cr4l',
        image: 'assets/image/Basic_Siemens_PLC_and_HMI_training_workshop.jpg',
      ),
    );
  }
}