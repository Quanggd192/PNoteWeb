-- Generated from the encrypted PNote desktop vault.
-- Target Supabase Auth user: quanggd192@gmail.com
-- Notes: 46

begin;

do $$
declare
  target_user_id uuid;
begin
  select id into target_user_id from auth.users where lower(email) = lower('quanggd192@gmail.com') limit 1;
  if target_user_id is null then
    raise exception 'Create the Supabase Auth user quanggd192@gmail.com before running this migration';
  end if;

  insert into public.profiles (id, email, display_name)
  values (target_user_id, 'quanggd192@gmail.com', 'Quanggd192')
  on conflict (id) do update set email = excluded.email;

  insert into public.workspaces (user_id, title, eyebrow, position)
  select target_user_id, seed.title, seed.eyebrow, seed.position
  from (values
    ('Reflect', 'Reset inward', 0),
    ('Cash Flow', 'Track movement', 1),
    ('Business & Investment', 'Sharpen conviction', 2)
  ) as seed(title, eyebrow, position)
  where not exists (
    select 1 from public.workspaces existing
    where existing.user_id = target_user_id and existing.title = seed.title
  );

  insert into public.menus (user_id, workspace_id, type, label, position)
  select target_user_id, w.id, menu.type, menu.label, menu.position
  from public.workspaces w
  cross join lateral (values
    ('journal', 'Journal', 0), ('dreams', 'Dreams', 1), ('reflection', 'Weekly Reflect', 2),
    ('oneThing', 'The One Thing', 3), ('routine', 'Routine', 4), ('study', 'Study', 5), ('brainstorm', 'Brainstorm', 6),
    ('note', 'Notes', 7)
  ) as menu(type, label, position)
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (workspace_id, type) do nothing;

  insert into public.menus (user_id, workspace_id, type, label, position)
  select target_user_id, w.id, menu.type, menu.label, menu.position
  from public.workspaces w
  cross join lateral (values ('capital', 'Capital Tracker', 0), ('weeklySpend', 'Weekly Spend', 1)) as menu(type, label, position)
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (workspace_id, type) do nothing;

  insert into public.menus (user_id, workspace_id, type, label, position)
  select target_user_id, w.id, menu.type, menu.label, menu.position
  from public.workspaces w
  cross join lateral (values ('business', 'Business', 0), ('investment', 'Investment', 1)) as menu(type, label, position)
  where w.user_id = target_user_id and w.title = 'Business & Investment'
  on conflict (workspace_id, type) do nothing;

  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'cf591c83-020e-4f34-a72a-6baef2888104'::uuid, target_user_id, w.id, m.id, 'Test 1', 'Justdoitnow01', 'note', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-01T08:19:14.930Z'::timestamptz, '2026-05-01T08:21:28.484Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'note'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '7d7cbb66-913b-4ed4-a312-d64b14269c6a'::uuid, target_user_id, w.id, m.id, 'Untitled — May 1', '', 'note', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-01T09:30:09.337Z'::timestamptz, '2026-05-01T09:30:09.337Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'note'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '9b34c519-1cbc-446c-a454-246736ce31f3'::uuid, target_user_id, w.id, m.id, 'Untitled — May 1', '', 'note', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-01T09:30:10.651Z'::timestamptz, '2026-05-01T09:30:10.651Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'note'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '8a8c7c05-7109-4c2d-a658-5eb822d4e5bb'::uuid, target_user_id, w.id, m.id, 'Untitled — May 1', '', 'note', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-01T09:30:11.362Z'::timestamptz, '2026-05-01T09:30:11.362Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'note'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '61d35754-ea13-432a-a6ee-9ef1e64cef0f'::uuid, target_user_id, w.id, m.id, 'Untitled', '', 'note', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-01T09:30:13.063Z'::timestamptz, '2026-05-01T09:30:13.063Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'note'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '43055d0e-c6fa-41b0-aebd-cb29a199e5b2'::uuid, target_user_id, w.id, m.id, 'Untitled', '', 'note', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-01T09:30:14.040Z'::timestamptz, '2026-05-01T09:30:14.040Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'note'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '1dc507a7-ba73-4b17-afa7-32586acaf080'::uuid, target_user_id, w.id, m.id, 'Untitled — May 1', '', 'note', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-01T09:30:14.839Z'::timestamptz, '2026-05-01T09:30:14.839Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'note'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'e094e540-a7df-4aa9-ada3-cfa82c907d9c'::uuid, target_user_id, w.id, m.id, 'Untitled Brainstorm', '{"nodeData":{"id":"root","topic":"Central Idea","children":[{"id":"m_moo2wjaa_72ug","topic":"Branch 1","children":[{"id":"m_moo2wjaa_p8et","topic":"Sub idea"},{"topic":"New topic","id":"de7d258d5f6e4eb9"}],"direction":0},{"topic":"New topic","id":"de7d267a52f5727a","direction":0,"children":[{"topic":"New topic","id":"de7d2fe1ff744ec5","children":[{"topic":"New topic","id":"de7d3134a6fa07b6"}]}]},{"id":"m_moo2wjaa_2efu","topic":"Branch 2","children":[{"id":"m_moo2wjaa_cwyk","topic":"Sub idea"}],"direction":1},{"id":"m_moo2wjaa_hd3n","topic":"Branch 3","direction":0}]},"arrows":[],"summaries":[],"direction":2,"theme":{"name":"Dark","type":"dark","palette":["#848FA0","#748BE9","#D2F9FE","#4145A5","#789AFA","#706CF4","#EF987F","#775DD5","#FCEECF","#DA7FBC"],"cssVar":{"--node-gap-x":"30px","--node-gap-y":"10px","--main-gap-x":"65px","--main-gap-y":"45px","--root-radius":"30px","--main-radius":"20px","--root-color":"#ffffff","--root-bgcolor":"#2d3748","--root-border-color":"rgba(255, 255, 255, 0.1)","--main-color":"#ffffff","--main-bgcolor":"#4c4f69","--main-bgcolor-transparent":"rgba(76, 79, 105, 0.8)","--topic-padding":"3px","--color":"#cccccc","--bgcolor":"#252526","--selected":"#4dc4ff","--accent-color":"#789AFA","--panel-color":"#ffffff","--panel-bgcolor":"#2d3748","--panel-border-color":"#696969","--map-padding":"50px 80px"}}}', 'brainstorm', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-02T08:24:21.082Z'::timestamptz, '2026-05-02T08:34:23.540Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'brainstorm'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '1bfd1116-312e-4da9-ab07-d11ee7f9eca9'::uuid, target_user_id, w.id, m.id, 'Weekly Reflection — May 3', '## What happened this week?
  - Chia tay ny cuối tuần trước, do bị drain energy khi bên cạnh nhau
  - Cảm thấy tiếc nuối và đã nói chuyện lại với cô ấy để xem có thể tiếp tục được hay không, kết quả là tiếp tục nhưng tiếp tục conflict :))
  - Nên mình quyết định dứt luôn, có thể làm bạn nhưng để 1 thời gian sau rồi nói chuyện.
  - Chuyển sang 1 dự án mới và vẫn đang trong giai đoạn ngồi chơi đợi dự án start
  - Có have sex với 2 em 2k5, 2k7. Không có vấn đề gì ngoại trừ mình bắt đầu thấy đuối
  - Cuối tuần 2 ngày liền thức khuya quá 3h, càng đuối, bắt đầu thấy đau ổ bụng
  - Ban đầu thì có lạm dụng bumble nhưng đến cuối tuần thì đã đỡ hơn
  - Vẫn dùng điện thoại rất nhiều
  - Bắt đầu đọc truyện Ông già trăm tuổi biến mất ở bậu cửa sổ. Đó là 1 câu chuyện đỉnh chóp, cụ Allan peak vl, mỗi tội cụ đéo có thật haha.
  - Vẫn xem content adult trên X, vẫn lên clone fb kiếm kèo :))
  - Đã có nhiều thời gian 1 mình hơn
  - Đã ra ngoài chơi với bạn (Ngọc Anh)
  
  ## What gave me energy?
  - Sách giết thời gian, thay vì lướt mxh
  - Thời gian reflect 1 mình
  - 1 chút thời gian với bạn bè
  - Dự án mới, con người mới đỡ phiền hơn.
  
  ## What drained me?
  Nhiều dopamin bẩn
  - X
  - Tìm kiếm kèo để have sex quá nhiều
  - Dùng điện thoại lướt mxh rất nhiều 
  - Mình vẫn tiếc nuối về mqh nhưng mình nghĩ nó không gây drain lắm
  
  ## What did I avoid?
  - Chẳng avoid được gì lắm
  - Giảm 1 chút thời gian dùng đthoai để đọc sách
  - Tránh dụ bạn mình vào 1 mqh rắc rối mới, haha. Just friend.
  
  ## What should change next week?
  - Giảm screen time
  - Tăng reading time
  - Không tìm kèo trên fb, những kèo hại ví nữa
  - Có thể dùng bumble nhưng ko quá nhiều
  - Có thể tiếp cận con gái bên ngoài nếu thấy năng lượng ổn định hơn
  - Tuần này mình đã dành nguyên ngày thứ 7 chỉ để ở nhà và recover, nhưng không recover được quá nhiều vì dùng đthoai và thức khuya quá, và hôm nay ra cafe work và thấy rất thiếu thời gian, vì còn 1 gym session. Tuần sau cần sửa điểm này. Ngày recover sẽ để tập chung work và đọc sách.
  
  ## Mức năng lượng tuần này
  Khoảng 30%
  - Mình nhận thấy là work càng lâu thì mình càng focus và đỡ mệt, tăng năng lượng.
  
  ### Whis Advice
  
  1. **Tách biệt cảm xúc**: Việc chia tay và cảm xúc tiếc nuối là tự nhiên. Hãy để thời gian giúp bạn hồi phục. Thay vì trở lại mối quan hệ cũ ngay lập tức, hãy tập trung vào bản thân và những sở thích cá nhân.
  
  2. **Quản lý năng lượng**: Điều chỉnh thói quen xung quanh các nguồn cung cấp năng lượng. Hãy cân nhắc giảm thiểu các hoạt động gây ra "dopamin bẩn" như xem nội dung không lành mạnh. Thay vào đó, đầu tư thời gian vào đọc sách và các hoạt động sáng tạo có ích.
  
  3. **Thời gian một mình**: Việc dành thời gian để tự suy ngẫm rất quan trọng. Hãy tiếp tục khám phá bản thân và sở thích của mình trong không gian yên tĩnh. Điều này giúp bạn nhận diện giá trị cá nhân và mong muốn trong cuộc sống.
  
  4. **Đặt mục tiêu cho bản thân**: Đổi mới và phát triển bản thân là quá trình liên tục. Hãy đặt ra những mục tiêu nhỏ hàng tuần, chẳng hạn như đọc một cuốn sách mới hoặc tham gia một hoạt động xã hội mới, để nâng cao kỹ năng và mở rộng mối quan hệ.
  
  5. **Xây dựng các mối quan hệ lành mạnh**: Hãy nhớ rằng tình bạn và các mối quan hệ tích cực là nền tảng cho sự phát triển cá nhân. Cố gắng xây dựng những mối quan hệ có ý nghĩa và tránh xa những tình huống có thể gây phiền phức hoặc xung đột.
  
  6. **Theo dõi sự thay đổi**: Hãy ghi lại những thay đổi mà bạn thực hiện mỗi tuần để thấy sự tiến bộ. Điều này không chỉ giúp bạn duy trì động lực mà còn cho phép bạn phản ánh và điều chỉnh chiến lược nếu cần.
  
  ## Mức năng lượng tuần này:
  - Mình nghĩ khoảng 60 - 65%', 'reflection', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-03T09:37:56.856Z'::timestamptz, '2026-05-16T04:26:51.629Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'reflection'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '2640d935-ec5e-44ff-ab14-e842d854495f'::uuid, target_user_id, w.id, m.id, 'New life style', '## I have to build a freaking life style
  
  - Outlook: quần áo, giày dép, body
  
  Maybe create a podcast
  Create a rap channel
  
  ', 'study', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-03T09:49:20.807Z'::timestamptz, '2026-05-30T03:04:28.350Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'study'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '394d84a9-bf03-41d8-a2a2-015d26f6ef4d'::uuid, target_user_id, w.id, m.id, 'Dream Log — May 10', '## Dream title:
  Game, gia đình, em gái
  ## Date and sleep context:
  Ngày cuối tuần, ngủ muộn tầm 3h đêm, ở trọ 1 mình, tối có nói chuyện với vài người bạn nhưng ko quá sâu và không muốn nói nhiều.
  
  ## Dream narrative (what happened?):
  
  Tôi vừa có 1 giấc mơ về gia đình.
  Trong mơ, đầu tiên tôi về quê chơi, hoặc đang sống ở quê, vẫn trong bối cảnh ngôi nhà cũ hồi nhỏ. Tôi không tiếp xúc trực tiếp với người lớn, chỉ nghe hoặc cảm nhận được họ nói chuyện ở xa. Tôi thấy rõ tiếng mọi người nói về đứa cháu gái bé nhất nhà (mọi người kể cả tôi đều dành tình yêu và quan tâm cho nó). Em họ tôi nói rằng 1 người họ hàng khác chê đứa cháu hơi còi. Nhưng nó vẫn rất khoẻ mạnh và xinh xắn, tôi nghĩ. Có 1 ai đó hoặc điều gì đó tác động, làm tôi trong 1 khoảnh khắc đừng trước gương check outfit, thấy mình ăn vận khá là cá tỉnh, kiểu mấy chàng trai hay ăn mặc nữ tính, như GD mặc váy hay sơn móng tay, nhưng trong mơ nó cường điệu hơn rất nhiều. Thú thực ngoài đời, không đời nào tôi ăn mặc nữ tình bằng 1/10 như vậy. Tuy nhiên lúc soi gương tôi lại nó khá đẹp, và tôi thấy hoàn toàn khoẻ mạnh, mình vẫn là 1 người đàn ông, không có chút biến chất nào ngoại trừ chút ngượng ngùng. Tôi đeo chiếc túi đeo chéo màu trắng, giống với cái tôi hay dùng ngoai đời thực gần đây, và đang chỉnh đi chỉnh lại độ dài phần quai đeo, 1 nửa để điều chỉnh, 1 nửa là để giải trí trong vô thức.
  (Vừa rồi tôi có tự hỏi liệu đứa cháu lớn lên có lạc lõng với gia đình mình như tôi?)
  Cảnh tiếp theo là tôi chơi 1 con game có vẻ như là phiêu lưu, có những con quái nhỏ từ level thâps đến cao, nhìn dễ thương nhưng những con level cao khá nguy hiểm và khi tôi bất cẩn đã tí nữa thì cắn chết nhân vật của tôi. Tôi bấm hồi máu liên tục, quay trở lại và farm những con quái level thấp để lấy kinh nghiệm và tiền. Có một "dòng sông chết chóc" bỗng nhiêu chảy dọc map, gọi như thế vì nhìn nó khá vô hại nhưng kiểu không được đi vào vì không biết bơi thì phải, tôi đi dọc theo nó đến cuối map. Cuối dòng sông, tôi gặp 1 ông già trông tri thức và khoẻ mạnh, và là người bình thường. Và bh tôi cũng là người bình thường. Dòng sông đã cụt nên tôi có thể đi lại thoải mãi sang phía bên kia. Và lúc này tôi lại biến thành tôi bình thường, không còn là nhân vật game. Tôi đang ở trong 1 khu nhà cho những người trung lưu và cận thuơngj lưu (ông già nói về điều đó). Những người xung quanh tôi nhìn khá đúng với mô tả đó, bản thân tôi cũng vậy. Tôi có nhận thức rằng mình vẫn đang làm 1 developer, và có cuộc sống khá, nhưng vẫn ở phía dưới trung bình so với những người ở đây (Nó bây giờ làm tôi liên tưởng đến nhà riêng của tôi bên smart city, dù nó có thể coi là khá ổn, nhưng trong cả khu vực thì căn nhà trong khu phân khúc thấp).
  Tôi nói với ông già rằng tôi phải làm tiếp việc của mình và chào ông, rồi đi về phía đầu của khu, là nơi gần nơi bắt đầu trò chơi. Có vẻ như đi đến đó thì tôi trở về ngôi nhà cũ hồi bé, ở đó nhà tôi, thậm chí là họ tôi đang chuẩn bị ăn cỗ. Có tiếng hát karaoke trong nhà, hình như tôi có hát 1 hay 2 bài để thể hiện với ai đó lạ măt, trình độ hát và rap của tôi thì gọi là out trình. Nhưng sau đó tôi không hát nữa và đi loanh quanh để làm việc, chuẩn bị đồ ăn tiếp khách. Mà tôi nghĩ đáng lẽ ra tôi bình thường sẽ hát nhiều hơn, nhưng hôm nay ko cần phải thể hiện, mà nên làm những việc cần làm hơn. Và điều tuyệt vời nhát trong giấc mơ xuất hiện. Tôi có 1 đứa em gái. Nó đã trưởng thành, và tôi cảm nhận rõ được tình máu mủ và nó là người có sự thấu hiểu, quan tâm, biết lắng nghe và quan trọng là không phán xet giống như tôi. Ngoài đời tôi cũng có 1 đứa em gái nhưng nó hoàn toàn ngược lại, và không hoàn toàn còn là con gái :))
  Cảm giác có 1 người thân như vậy là 1 niềm hạnh phúc khó diễn tả. Tôi nói chuyện với nó bình thường, có vẻ anh em mới nhận nhau nên còn 1 chút "lạ" giữa cả 2, nhưng tôi vẫn cảm nhận được mọi thứ ở nó. Tôi để mắt đến việc làm đồ ăn, và mấy đôi giày bẩn bams đầy bùn đất mà nãy tôi đi đánh quái về cần được làm sạch. Và thịt được nướng như trộn với đất ở bụi chuối bên trái nhà. Tôi thấy em gái tôi ngồi với 1 thằng bạn trai, có vẻ nó cũng mới quen, nhìn nó khá hiền lành, và có chính kiến, làm tôi có thiện cảm, nên tôi tôn trọng và để bọn nó được riêng tư. Sau đó nó muốn dẫn th bạn vào ăn trước cho nó đi về sớm có công việc, tôi khoác vai dặn nó lấy nhiều đồ ăn cho bạn rồi 2 đứa cùng ăn đi, nó có chút trách yêu là anh cứ dặn nhiều, nhưng vẫn mỉm cười và chào tôi rồi đi. Tôi quay lại nướng thịt trong bụi chuối, và mẹ tôi nói chuyện từ cửa sổ phía bên trên, rằng bọn em họ lít nhít của tôi muốn chơi kẻ mắt son môi và eyeliner,.. nhưng tôi không có đồ chơi đó. Tôi suy nghĩ và vui mừng nhận thấy mình có những thứ kiểu như vậy, mặc dùng ko phải chuyên nghiệp, nhưng có thể dùng được, ở trong bộ đồ chơi lego của tôi. Tôi nói với mẹ như vậy và tiếp tục nướng thịt.
  
  Key symbols / archetypes:
  - 
  - 
  - 
  
  ## Emotions during dream and after waking:
  - Tâm lý ổn định
  - Hạnh phúc khi có em gái
  ## Associations from waking life:
  
  ## Active imagination / next reflection step:
  Claude có hỏi mình 1 câu khá hay: Nhắm mắt lại và tưởng tượng 1 điều mà cô em gái muốn nói với mình?
  Mình nghĩ nó sẽ là: "Em yêu thương anh và sẽ luôn ở đây vì anh. Hãy làm điều tương tự với em nhé!"
  Mình muốn liên hệ với mối tình 2 tháng vừa kết thúc. Mình nghĩ cả 2 đều muốn làm điều đó, nhưng khi ny mình chia sẻ quá nhiều về những chuyện tiêu cực, ko liên quan và mình ko quan tâm thì mình bắt đầu thấy mệt mỏi dần và không còn present hoàn toàn như trước nữa. 
  
  ChatGPT: "Một người khiến anh không phải rời khỏi chính mình khi ở cạnh họ."
  
  
  ', 'dreams', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-10T03:21:02.231Z'::timestamptz, '2026-05-10T07:06:42.650Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'dreams'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '2882b09f-faeb-4abf-a8c5-fbd6636227ba'::uuid, target_user_id, w.id, m.id, 'Road to 200tr', '{
    "kind": "progression-v1",
    "description": "Road to 200 triệu",
    "items": [
      {
        "id": "prog_1778403670482_hhan1l_4",
        "label": "First milestone",
        "checked": false
      },
      {
        "id": "prog_1778403670482_hfmr13_5",
        "label": "Second milestone",
        "checked": false
      },
      {
        "id": "prog_1778403670482_skr5io_6",
        "label": "Launch",
        "checked": false
      }
    ]
  }', 'business', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-10T09:01:10.588Z'::timestamptz, '2026-05-10T09:01:38.116Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'business'
  where w.user_id = target_user_id and w.title = 'Business & Investment'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'e285fb6c-581d-45c9-ae96-a6101217f68a'::uuid, target_user_id, w.id, m.id, 'Investment Thesis — May 10', 'Asset / Ticker:
  
  Thesis:
  
  Catalysts:
  
  What could go right?
  
  What could break the thesis?
  
  Risk management:
  ', 'investment', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-10T09:02:07.119Z'::timestamptz, '2026-05-10T09:02:07.119Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'investment'
  where w.user_id = target_user_id and w.title = 'Business & Investment'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'b399cd71-9156-4971-aea9-c2c7c33fc816'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '# Capital Dashboard
  
  ## Snapshot
  Date:
  
  Total net worth:
  
  Liquid assets:
  
  Invested capital:
  
  Debt / liabilities:
  
  ## Allocation
  - Cash:
  - Equities:
  - Crypto:
  - Business equity:
  - Real estate:
  - Other:
  
  ## Growth Velocity
  Starting net worth:
  
  Current net worth:
  
  Absolute growth:
  
  Growth rate (%):
  
  Monthly growth speed:
  
  Next milestone:
  
  ## Key Drivers
  What moved the number this period?
  
  ## Decisions
  What should I do next to compound better?
  ', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-10T09:12:36.131Z'::timestamptz, '2026-05-10T09:12:36.131Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '0b91b0ee-af0a-47ea-a5cd-11f9034bfff4'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '{
    "version": 1,
    "goalAmount": 1000000,
    "targetYears": 10,
    "categories": [
      {
        "id": "capital_cash",
        "name": "Cash",
        "amount": 59999600,
        "annualGrowthRate": 9
      },
      {
        "id": "capital_equities",
        "name": "VN30",
        "amount": 10000000,
        "annualGrowthRate": 15
      },
      {
        "id": "capital_business",
        "name": "VNDiamond",
        "amount": 10000000,
        "annualGrowthRate": 20
      },
      {
        "id": "capital_1778406047851_gyh5m",
        "name": "Gold",
        "amount": 8300000,
        "annualGrowthRate": 50
      },
      {
        "id": "capital_1778406098643_04bcs",
        "name": "Cash2",
        "amount": 20000000,
        "annualGrowthRate": 5
      }
    ]
  }', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-10T09:12:36.133Z'::timestamptz, '2026-05-16T03:18:14.558Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '92a16058-1ccf-48c5-a056-505524490315'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '# Capital Dashboard
  
  ## Snapshot
  Date:
  
  Total net worth:
  
  Liquid assets:
  
  Invested capital:
  
  Debt / liabilities:
  
  ## Allocation
  - Cash:
  - Equities:
  - Crypto:
  - Business equity:
  - Real estate:
  - Other:
  
  ## Growth Velocity
  Starting net worth:
  
  Current net worth:
  
  Absolute growth:
  
  Growth rate (%):
  
  Monthly growth speed:
  
  Next milestone:
  
  ## Key Drivers
  What moved the number this period?
  
  ## Decisions
  What should I do next to compound better?
  ', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-10T09:37:25.904Z'::timestamptz, '2026-05-10T09:37:25.904Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '501507f5-cfbb-4a6d-a206-7928d8f6e0f1'::uuid, target_user_id, w.id, m.id, 'Chuyện yêu đương', '## Tường thuật
  
  Tôi có 1 cô người yêu, trong mơ cô ta giống 1 người đồng nghiệp cũ, bằng tuổi tôi (khá lớn tuổi so với mẫu người yêu thực tế của tôi). Cô ta có 1 thằng bạn thân. Thằng này có vẻ yếu đuối và kém tinh tế, có lẽ đó là lý do tôi ko thích nó. Khi tôi yêu cô ta thì thằng này không bao giờ bén mảng đến nhà cô. Nhưng một hôm, tôi và cô gái chia tay. Thằng bạn thân bắt đầu sang nhà cô chơi liên tục. Nó mang rau ngót sang mời bố ny tôi húp canh để lấy lòng. Bố ny tôi húp xong thì bị ngộ độc (trong mơ ông bị dị ứng với chất đạm).
  Có vẻ việc đó không làm ảnh hưởng đến thằng bạn kia lắm, vì nó vẫn sang nhà cô gái liên tục. Mẹ cô gái vẫn nói chuyện với nó, có vẻ bác là người rất dễ chịu và thoải mái vì bác vẫn tiếp thằng kia. Cô gái dường như tránh mặt nó vì tôi ko thấy cô ta đâu. Có vẻ thằng kia có tình ý và cô gái ko thích điều đó.
  Thằng kia ở lì nhà cô gái, nằm dài trên sofa, xem TV và nch với mẹ cô gái. Tôi đã có thể nhận xét rằng nó vô duyên từ đây. Rồi có vẻ bác gái cũng bắt đầu chán nó dù ko thể hiện ra, bác bắt đầu nhắc về tôi - người yêu cũ - của cô gái trong cuộc trò chuyện.
  
  ## Key symbols:
  - Cô người yêu giống đồng nghiệp cũ
  → Hình mẫu “người phụ nữ trưởng thành/thực tế/xã hội”, không hoàn toàn là fantasy tình yêu của anh.
  - Thằng bạn thân yếu đuối, kém tinh tế
  → Archetype của kiểu đàn ông thiếu khí chất nhưng thích len vào khoảng trống cảm xúc/xã hội.
  - Chỉ xuất hiện sau chia tay
  → Biểu tượng của opportunism: không cạnh tranh trực diện, chỉ bước vào khi hệ thống mất cân bằng.
  - Mang rau ngót sang lấy lòng
  → Hành động “good guy/social pleasing”; cố tạo giá trị bằng sự chăm sóc bề mặt.
  - Bố ny bị ngộ độc
  → “Ý tốt nhưng gây hại”; thiếu hiểu người khác nên lòng tốt trở thành intrusion.
  - Mẹ vẫn tiếp chuyện lịch sự
  → Biểu tượng của social tolerance: xã hội thường vẫn lịch sự với người vô duyên thay vì đuổi thẳng.
  - Cô gái tránh mặt / không xuất hiện
  → Trung tâm cảm xúc thật đang rút lui; có thể là biểu tượng của sự không đồng thuận ngầm.
  - Nằm lì trên sofa xem TV
  → Symbol cực mạnh về vượt ranh giới, chiếm không gian không thuộc về mình, ký sinh cảm xúc/social comfort.
  - Mẹ bắt đầu nhắc về anh
  → Psyche của anh tự khẳng định rằng “giá trị thật rồi sẽ được nhận ra”, khác với kiểu lấy lòng ngắn hạn.
  - Anh đứng ngoài quan sát thay vì đánh nhau
  → Ego đang ở trạng thái quan sát, đánh giá phẩm chất con người hơn là phản ứng cảm tính hay chiếm hữu.
  
  ## Jungian reflection:
  - Giấc mơ phản ánh sự khó chịu của anh với kiểu người thiếu tinh tế nhưng vẫn cố chen vào không gian thân mật của người khác.
  - “Thằng bạn thân” tượng trưng cho kiểu đàn ông yếu khí chất, không đối đầu trực diện nhưng dùng sự thân quen và lấy lòng để hiện diện.
  - Chi tiết “rau ngót làm bố ny ngộ độc” thể hiện ý tưởng rằng ý tốt nhưng thiếu awareness vẫn có thể gây hại.
  - Cô gái tránh mặt và mẹ cô dần chán nó cho thấy unconscious của anh vẫn tin giá trị thật sẽ tự được nhận ra theo thời gian.
  - Trọng tâm giấc mơ không phải mất người yêu, mà là cảm giác bị xâm phạm ranh giới và việc đánh giá phẩm chất con người.
  
  
  ', 'dreams', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-16T03:18:48.227Z'::timestamptz, '2026-05-16T04:26:36.418Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'dreams'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'e901a7b1-3a9b-418c-a7e7-4e3718f5f20d'::uuid, target_user_id, w.id, m.id, 'Weekly Reflection - May 16', '## What happened this week?
  
  - Không có gì nhiều, dự án bắt đầu chạy, công việc vẫn nhàn nhã (do AI mạnh).
  - Mấy thằng leader ngu, mình đã than vãn về chuyện này với ChatGPT và maybe cả con người (không nhớ là ai). Theo mình thì mấy thằng này ko cùng đẳng cấp, ko phải tính về kinh tế, hay năng lực chuyên môn, mà về 1 thứ khác. Mà cũng khó có ai mà mình xem là cùng đẳng cấp trong số đồng nghiệp :)) Vậy hãy nói về cốt cách, theo mình thì bọn này cốt cách hơi kém. Không hiểu chuyện lắm. Mình vẫn thấy hơi rối, có lẽ sẽ phân tích sau, hoặc ko care nữa cho nhẹ.
  - Mình cũng không đọc kỹ requirement lol =)).
  - Vẫn dùng đth nhiều nhưng đã giảm đáng kể, trung bình hơn 5h, vẫn xem porn.
  - Đọc xong cuốn "Ông già trăm tuổi trèo qua cửa sổ".
  - Vẫn tìm sinh viên nghèo =))
  
  ## What drained me?
  - Chê bọn leader ngu hơi nhiều
  - Screen time nhiều - dopamine fried
  - Tìm sv nghèo hơi nhiều - attention leak
  - Porn hơi nhiều 1 chút - dopamine fried
  
  ## What gave me energy?
  
  - Cảm giác hoàn thành công việc
  - Dậy sớm và ngủ sớm thành thói quen cộng với việc bế tinh đc hơn 4 ngày
  - Ahh, sách nữa, Ông già trăm tuổi trèo qua cửa sổ là 1 tiểu thuyết tuyệt vời, Nó vừa lạ khi nói về 1 cụ già 100 tuổi mà tính cách như 20 tuổi, vừa có lối kể trực diện nhưng tinh tế, bất ngờ, hài hước và lôi cuốn, hơn nữa lại liên kết với các nhân vật và sự kiện lịch sử có thật nên rất bánh cuốn. Có lẽ đây là tiểu thuyết mình thích nhất, cùng với Sherlock Holmes.
  
  ## What did I avoid?
  - Not really haha
  
  ## What should change next week?
  - giảm thêm 1–2h screen time, lets say about 4hours average screen time.
  - tạo 1 thứ gì đó thật sự của riêng mình (nhạc/workshop/project)
  - và ngừng mentally fighting với leader
  
  ', 'reflection', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-16T03:38:21.890Z'::timestamptz, '2026-05-16T04:09:57.678Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'reflection'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '639d9af7-adcd-4f01-ab4a-469f82ff19bb'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '{
    "version": 1,
    "goalAmount": 1000000000,
    "targetYears": 1,
    "categories": [
      {
        "id": "capital_cash",
        "name": "Cash saving",
        "amount": 60000000,
        "annualGrowthRate": 8,
        "monthlyContribution": 0
      },
      {
        "id": "capital_equities",
        "name": "Stocks",
        "amount": 26000000,
        "annualGrowthRate": 15,
        "monthlyContribution": 15000000
      },
      {
        "id": "capital_business",
        "name": "Gold",
        "amount": 8100000,
        "annualGrowthRate": 20,
        "monthlyContribution": 2000000
      },
      {
        "id": "capital_1778906968049_b7alt",
        "name": "Flexible cash",
        "amount": 2000000,
        "annualGrowthRate": 5,
        "monthlyContribution": 1000000
      }
    ]
  }', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-16T04:27:54.415Z'::timestamptz, '2026-06-28T02:58:24.933Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '2f0ad32c-2b4a-4c3e-a216-9c063a9f162d'::uuid, target_user_id, w.id, m.id, 'Nhà, zombies và Arsenal vô địch', '## Dream narrative:
  
  Tôi xuất hiện trong ngôi nhà cũ hồi bé, lần này nhìn nó sạch đẹp, khang trang hơn bình thường, và có 1 chút vibe lai giữa vintage, indochine và fresh. Bên ngoài đoàn quân zombie đang đến. Khắp nơi là zombie, và mưa rất to. Và ngôi nhà bằng cách nào đó là bất khả xâm phạm với bọn zombie. Có vẻ như cơn mưa có thể làm bọn chúng suy yếu, và không thể xâm phạm ngôi nhà.
  
  Một cảnh khác, vẫn tôi ở trong ngôi nhà, và ngoài ngõ có 1 cậu bé (lúc này không có zombies) chạy và hô to: Arsenal vô địch rồi. Điều đó có nghĩa là Arsenal thắng Burley và Man city thua đội nào đó, Arsenal vô địch sớm 1 vòng đâú. Tôi tất nhiên vô cùng phấn khởi khi ghe tin, và không hiểu vì sao mình lại biết tin đó sau 1 cậu bé, nhưng vẫn phấn khởi. Sau đó tôi lên web check lại (trong mơ) và có vẻ như tôi nhận thức được rằng thông tin kia không đúng, và tôi đang ở trong 1 giấc mơ.
  
  ## Key symbols:
  -Ngôi nhà cũ thời thơ ấu
  → Core self, ký ức nền tảng, vùng an toàn tâm lý, identity nguyên bản.
  Ngôi nhà được nâng cấp / sạch / đẹp / indochine-vintage-fresh
  → Sự trưởng thành nội tâm, tái cấu trúc bản thân theo hướng có gu, có chiều sâu hơn thay vì chỉ “hoài niệm”.
  Zombie
  → Đám đông vô thức, năng lượng độc hại, sự draining, con người sống auto-pilot, social chaos.
  Zombie ở khắp nơi
  → Cảm giác thế giới ngoài kia hơi hỗn loạn / khó đồng điệu / mentally exhausting.
  Ngôi nhà bất khả xâm phạm
  → Boundary mạnh hơn, inner fortress, khả năng giữ bản thân không bị nuốt bởi môi trường.
  Mưa lớn
  → Thanh lọc cảm xúc, reset tâm lý, unconscious cleansing.
  Mưa làm zombie yếu đi
  → Sự thật, cảm xúc thật, self-awareness hoặc healing đang làm yếu các năng lượng toxic.
  Cậu bé chạy báo tin Arsenal vô địch
  → Inner child mang tin hy vọng / niềm vui thuần khiết / phần hồn nhiên trong anh.
  Arsenal vô địch sớm 1 vòng
  → Khao khát một “happy ending” khó tin nhưng rất mong xảy ra; cảm giác được công nhận hoặc chiến thắng sau thời gian dài chờ đợi.
  Check web để verify
  → Tư duy logic, reality-check, không muốn bị cuốn hoàn toàn bởi cảm xúc hoặc fantasy.
  Nhận ra thông tin sai
  → Khả năng phân biệt illusion vs reality đang mạnh lên.
  Nhận ra mình đang mơ
  → Meta-awareness, self-observation, ý thức đang bắt đầu “thức tỉnh” ngay cả trong vô thức.
  Ngoài ngõ
  → Ranh giới giữa “thế giới bên ngoài” và “thế giới riêng” của anh. Tin tức/ảnh hưởng từ ngoài đời đang cố đi vào psyche.
  
  ## Jungian reflection:
  
  Giấc mơ này có thể tóm lại như:
  
  “Giữa một thế giới hỗn loạn và vô thức, anh đang dần xây được một không gian nội tâm an toàn hơn. Anh vẫn còn hy vọng và phần trẻ con bên trong, nhưng đồng thời cũng ngày càng tỉnh táo để phân biệt giữa fantasy và reality.”
  
  Nó không có vibe tiêu cực nhiều. Ngược lại, khá “solid”.
  Đặc biệt là hình ảnh:
  
  căn nhà đứng vững giữa zombie + mưa bão
  
  …là một biểu tượng tâm lý khá mạnh đấy anh.
  
  Nếu gom thành 3 cụm lớn thì giấc mơ này xoay quanh:
  - Protection / boundaries
  - Hope vs reality
  - Awareness / awakening
  ', 'dreams', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-17T05:56:15.651Z'::timestamptz, '2026-05-17T06:17:07.570Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'dreams'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '3dca7e3a-613f-47a5-a9db-c5d464484882'::uuid, target_user_id, w.id, m.id, 'Weekly Spend', '{
    "version": 1,
    "weekLabel": "This week",
    "startDate": "2026-05-11",
    "endDate": "2026-05-17",
    "totalBudget": 2000000,
    "categories": [
      {
        "id": "weekly_food",
        "name": "Food",
        "budget": 1200000,
        "spent": 1200000
      },
      {
        "id": "weekly_transport",
        "name": "Transport",
        "budget": 150000,
        "spent": 150000
      },
      {
        "id": "weekly_social",
        "name": "Social/Entertain",
        "budget": 750000,
        "spent": 300000
      },
      {
        "id": "weekly_misc",
        "name": "Nước hoa",
        "budget": 0,
        "spent": 3500000
      },
      {
        "id": "weekly_spend_1779002892855_hsdzc",
        "name": "Sex",
        "budget": 0,
        "spent": 3000000
      },
      {
        "id": "weekly_spend_1779005882643_630v7",
        "name": "Massage",
        "budget": 0,
        "spent": 450000
      }
    ]
  }', 'weeklySpend', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-17T06:45:45.119Z'::timestamptz, '2026-05-17T08:18:45.993Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'weeklySpend'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'c046a3e1-1846-481d-a9b6-d79a21978dd5'::uuid, target_user_id, w.id, m.id, 'Weekly Spend — 2026-05-18 → 2026-05-24', '{
    "version": 1,
    "weekLabel": "This week",
    "startDate": "2026-05-18",
    "endDate": "2026-05-24",
    "totalBudget": 2000000,
    "categories": [
      {
        "id": "weekly_food",
        "name": "Food",
        "budget": 1300000,
        "spent": 1300000
      },
      {
        "id": "weekly_social",
        "name": "Entertain",
        "budget": 700000,
        "spent": 700000
      },
      {
        "id": "weekly_spend_1779132098790_25te1",
        "name": "Medicine",
        "budget": 0,
        "spent": 110000
      },
      {
        "id": "weekly_spend_1779132110360_91cg1",
        "name": "Service",
        "budget": 0,
        "spent": 5200000
      }
    ]
  }', 'weeklySpend', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-17T07:40:05.095Z'::timestamptz, '2026-05-24T15:25:58.436Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'weeklySpend'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'f9b3a234-bfe8-496f-af02-a8c6626504a9'::uuid, target_user_id, w.id, m.id, 'Untitled', 'Mình nhận ra rằng buổi tối, sau khi tập và cần được recover thì nên đến những nơi yên tĩnh thay vì náo nhiệt.
  Hôm qua mình có đi nghe Acoustic với 1 người bạn mới quen, vui nhưng ồn ào. 
  Sáng nay dậy dù ngủ khá so với bình thường nhưng vẫn thấy người mệt và hơi nặng nề.', 'journal', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-17T08:20:37.779Z'::timestamptz, '2026-05-17T08:22:33.025Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'journal'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'e0bb3349-fa37-4358-afba-05436c51009c'::uuid, target_user_id, w.id, m.id, 'Bé gái với sự yêu quý, đánh nhau, năng lực', '## Dream narrative:
  
  Tôi đang xem 1 bộ phim hoặc xem trực tiêps 1 sự kiện gì đó, có vẻ như sự thi thố giữa 1 team nội bộ, vì không khí khá là thân mật, có cạnh tranh nhưng không có sự thù địch và ko quá căng thẳng. Có 2 thanh niên có vẻ là người xuất sắc nhất, khi bắt đầu cuộc đua, họ là 2 người đầu tiên lao đi, có 1 cánh cổng với tường gạch dày chắn giữa đường đi, giống như cổng làng kiểu phong kiến đông á, nhưng tường dày và gạch mới màu xám đen như châu Âu, liên tưởng tới bức tường ở nhà ga 9 3/4 trong Harry Potter. 2 thanh niên nhanh nhảu lao qua đó. Những người khác nhìn thấy và khá là bình tĩnh, tự tin và thầm cười sự nóng vội của 2 cậu kia. Có lý do để họ cười, vì khi họ bắt đầu đi qua đó, khoảng 1, 2s sau, từng người một, bằng cách nào đó cánh cổng giúp họ kích hoạt 1 năng lực đặc biệt gì đó, đoạn này có stop motion, slow motion, có hiệu ứng kỹ xảo nhìn khá oách, và giúp họ bù đắp sự thiệt thòi của xuaats phát sau, và có lợi hơn 2 người đi trước theo 1 cách nào đó mà tôi chưa nhận ra, vì trông họ rất tự tin, bình tĩnh và đắc ý. Team này có vibe làm tôi liên tuơngr tới Avengers, hoặc team Earth Relm trong Mortal Kombat, 2 người đầu tiên có năng lực cao nhất nhưng nóng vội.
  
  Sau đó tôi đi bộ về nhà và gặp 1 cô bé dễ thương, cô ở cùng khu với tôi, có cảm giác ở trong 1 nhà, và lúc này là cô bé khoảng 10 tuổi. Có 1 sự tương đồng nào đó, khi tôi chắc mẩm mình đi trước và sẽ thắng cô bé thì cô bé xải những bước dài và đi nhanh hơn tôi, và cười tôi không hiểu về con đường và cách đi một cách trêu chọc. Sau đó tôi đi theo cô bé, 2 người đi cùng nhau.
  
  Chuyển cảnh, cô bé - cảnh này đã lớn, khoảng 16-18 tuổi, đang làm phục vụ tại 1 quán ăn, cùng với người chị ruột của mình. Tôi đến ngồi ăn, tôi có cảm giác mình là khách nhưng sau đó cô bé đến ngồi ăn với tôi. Cô khá quý tôi, kiểu có tình cảm nam nữ, nhưng vẫn còn thẹn, phía tôi cũng tương tự, vì không thể ko thích nguồn năng lượng trẻ trung, lương thiện và vô tư như vậy. Quán có 2 thằng nhân viên nữa, 1 thằng bình tĩnh và 1 thằng trẩu, nhưng bọn n có vẻ cùng 1 phe và đều có vẻ ko thích tôi lắm, đặc biệt là thằng trẩu. Thằng trẩu thích cô bé, nó bắt cô bé ngồi cạnh nó 1 cách thân mật. Tôi nói chuyện lịch sự với nó về điều đó, cô bé bày tỏ sự khó chịu và muốn ngồi với tôi. Thằng trẩu gây sự với tôi dù nó bé hơn tôi, và nó tác động vật lý tôi, và đó là sai lầm của nó. Ở cảnh này, tôi thấy sau khi tát tôi 1 cái, nó bị tôi quật ngã và dúi vào giữa mặt 3 nắm đấm, tôi hình dung thấy gò má nó vỡ nát. Nhưng lúc đó tôi lại tách mình ra vị trí quan sát. Sau đó cô bé lại trở về ngồi với tôi 1 cách an toàn, chúng tôi lại ngồi ăn cơm với vài nhân viên quá.
  1 cảnh khác cũng ở quán, thì nay có vẻ lại trở thành bếp của hoàng cung, cô bé và chị cô đang vui vẻ chơi với hoàng đế, có vẻ đang nhảy nhót và quay tiktok. Hoàng đế địa vị rõ ràng rất cách biệt, nhưng khá thân mật với 2 chị em. Cô bé lúc này vẫn 16-18t, thân hình đẹp, cao và gầy, đôi chân dài, tay thon, da trắng mịn.
  Tối qua trước khi xem bóng đá thì tôi có đọc nốt phần truyền Sherrlock Holmes về kẻ báo thù xứ Utah, có thể giấc mơ này lấy chất liệu từ đó, có 1 anh chàng yêu 1 cô gái giáo phái Mormont, cô gái bị ép gả cho 1 trong 2 thanh niên trong giáo phái. 2 thằng đó giết chết cha cô gái, sau đó cô gái héo hon mà chết. Anh chằng, sau khi dẫn 2 người đó bỏ chốn bất thành, đã bám đuổi 2 thằng kia suốt 20 năm, từ Utah Mỹ qua Perterburgs Nga, qua các thành phố châu Âu, rồi đến Liverpool Anh và cuối cùng giết được 2 thằng ở London trước khi bị Sherlock Holmes tóm. Lúc bị bắt anh bày tỏ sự mãn nguyện vì đã đòi được công bằng cho cha con người yêu, sau đó chết trong danh dự vì bệnh phình động mạch chủ.
  
  ## Key symbols:
  -Cổng/tường gạch: ngưỡng chuyển cấp, luật ẩn, cơ chế kích hoạt năng lực.
  Hai người lao trước: tài năng + nóng vội.
  Team Avengers/Mortal Kombat: đội hình nhiều archetype bên trong anh.
  Cô bé: trực giác trẻ, sự hồn nhiên, anima, nguồn sống sạch.
  Bước dài: đi đúng nhịp, hiểu đường, không cần vội.
  Quán ăn: nhu cầu kết nối, chăm sóc, thân mật đời thường.
  Thằng trẩu: nam tính thấp cấp, chiếm hữu, cạnh tranh bẩn.
  Hoàng đế: nam tính cao cấp, quyền lực ung dung.
  Anh đứng quan sát: ý thức tách khỏi bản năng, bắt đầu kiểm soát được aggression.
  
  ## Jungian reflection:
  Giấc mơ này nói rằng: anh đang quan sát và nhận ra kiểu “lao nhanh để thắng” so với kiểu “hiểu cửa, hiểu đường, giữ phong thái; quyền lực thật không cần vội và không cần giành giật.”
  Ngoài ra là banr năng hung hăng bạo lực đi kèm ý thức kiểm soát.', 'dreams', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-19T02:31:05.045Z'::timestamptz, '2026-05-19T03:05:00.308Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'dreams'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '54a917c9-deb6-46a4-a392-041393e2a511'::uuid, target_user_id, w.id, m.id, 'Mất năng lượng', 'Qua mình thức khuya xem bóng đá, lúc 2h, dù hôm nay thứ 3.
  Điều đó được cho phép vì chỉ còn 2 vòng cuối và mình rất muốn cổ vũ đội bóng tôi yêu.
  Điều không nên xảy ra là mình nứng, gọi sinh viên mất 2tr, và xuất tinh lần, buổi đêm bị xáo trộn, gọi đúng 1 con hâm và hãm, tuy tâm trạng mình ko ảnh hưởng lắm, nhưng buổi đêm diễn ra lộn xộn.
  Công với việc xuất tinh 2 lần, mình thấy năng lượng dồi dào trước đó sáng nay đã vơi đi lúc thức dậy. Giọng nói yếu hơi và không còn bật mạnh như hôm qua. 
  Sự nứng cùng với suy nghĩ vừa xem bóng vừa hưởng thụ tình dục khiến mình bứt rứt và dùng dằng, dành cả tiếng để nhắn tin cho mấy em sinh viên, làm buổi tối diễn ra không theo trật tự, luôn đứng giữa ranh giới bảo toàn hay sa ngã, và khó ngủ ngon. Mãi sau khi đã sa ngã và xem xong bóng đá, mình mới ngủ được.
  ', 'journal', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-19T03:06:34.273Z'::timestamptz, '2026-05-19T03:12:48.508Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'journal'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'fe726ff7-3dff-474a-ae23-7539ba290eaa'::uuid, target_user_id, w.id, m.id, 'Weekly Spend — 2026-05-25 → 2026-05-31', '{
    "version": 1,
    "weekLabel": "This week",
    "startDate": "2026-05-25",
    "endDate": "2026-05-31",
    "totalBudget": 2000000,
    "categories": [
      {
        "id": "weekly_food",
        "name": "Food",
        "budget": 1300000,
        "spent": 1300000
      },
      {
        "id": "weekly_transport",
        "name": "Transport",
        "budget": 150000,
        "spent": 150000
      },
      {
        "id": "weekly_social",
        "name": "Service",
        "budget": 600000,
        "spent": 1000000
      },
      {
        "id": "weekly_misc",
        "name": "Coffee",
        "budget": 200000,
        "spent": 150000
      }
    ]
  }', 'weeklySpend', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-30T02:10:00.686Z'::timestamptz, '2026-05-30T02:12:43.389Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'weeklySpend'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '7d40ab05-ac27-40f5-a2eb-e5be5cad7a04'::uuid, target_user_id, w.id, m.id, 'Weekly Reflection', '## Tuần này có gì không?
  
  - Không có gì nhiều
  - Mình đã hoàn toàn không nghĩ gì về nyc
  - Có have sex 1 hay 2 lần gì đó
  - Không care lắm tới mấy thằng leader
  - Mình đang nghĩ đến việc đổi môi trường, nếu tìm được 1 chỗ thực sự ngon nghẻ hơn.
  Maybe mình sẽ dành thời gian học thêm kiến thức mới và build thêm project để có lợi thế ứng tuyển.
  
  ## What drained me?
  Nah
  
  ## What to improve?
  
  - Kiểm soát được năng lượng của mình. Sau khoảng 5 ngày ko xuất tinh thì năng lượng của mình sẽ lên khá cao, và mình sẽ có nhu cầu have sex cao. Hãy thử vượt qua giai đoạn này và xem nó sẽ như thế nào.
  - Học AI
  - Nghiên cứu thị trường nước ngoài xem người ta cần gì nhiều và tập trung học thứ đó thật giỏi.
  - Dù sao thì nó cũng sẽ nhiều tự do hơn là đi làm office. Mình sẽ cân nhắc chuyện nghỉ việc sau khi nhận thưởng vào tháng 7. Khoảng 20 củ gì đó.
  ', 'reflection', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-05-30T02:39:28.282Z'::timestamptz, '2026-05-30T02:45:15.532Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'reflection'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'bb4040d9-14f7-4292-a0f9-2c7bbf964dcb'::uuid, target_user_id, w.id, m.id, 'Weekly Spend — 2026-06-01 → 2026-06-07', '{
    "version": 1,
    "weekLabel": "This week",
    "startDate": "2026-06-01",
    "endDate": "2026-06-07",
    "totalBudget": 2000000,
    "categories": [
      {
        "id": "weekly_food",
        "name": "Food",
        "budget": 1300000,
        "spent": 1300000
      },
      {
        "id": "weekly_transport",
        "name": "Transport",
        "budget": 150000,
        "spent": 150000
      },
      {
        "id": "weekly_social",
        "name": "Massage",
        "budget": 550000,
        "spent": 1000000
      },
      {
        "id": "weekly_misc",
        "name": "Hotel",
        "budget": 0,
        "spent": 520000
      }
    ]
  }', 'weeklySpend', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-06T06:22:03.183Z'::timestamptz, '2026-06-06T07:07:48.004Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'weeklySpend'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '2c12012c-eed3-4937-aa1b-0d9fea6861d9'::uuid, target_user_id, w.id, m.id, 'Weekly Reflection', '## Tuần này có gì không?
  
  - Mình bị ốm 3 hôm t5,t6, đến hôm này đã đỡ 1 chút
  - Phải bỏ tập khá nhiều
  - Vướng vào mqh nhập nhằng với mấy em 1 lúc, mình cần manage chuyện này tốt hơn
  - Kế hoạch tài chính bị đổ bể tương đôí, vì mẹ mình cần tiền để xây nhà. Mình cực ghét cái cách bố mẹ mình kiểm soát mọi thứ của mình. Không phải là 1 caí cớ để bào chữa, nhưng nếu ông bà biết tôn trọng ranh giới, fair hơn và rõ ràng hơn trong chuyện tiền nong thì mình sẽ vui vẻ đưa tiền thôi, kể cả có hết tiền tài khoản còn 0đ thì cũng chẳng sao. Đằng này mình thấy rằng ông bà bô là những người kiểm soát triệt để, và thao túng mình quá kinh khủng. Dù ông bà không có ý thức về việc đấy đi nữa, thì đấy cũng không phải 1 cái cớ để biện minh. Mình bị đẩy vào cái thế mà, nếu đưa tiền thì trong tay chẳng có gì, còn nếu không thì mang tiếng bất hiếu không thương bố mẹ.
  Ông bà mua nhà cho mình nhưng thực chất giấy tờ vẫn đứng tên ông bà, mình chẳng thể dùng nó làm vốn, chẳng làm được gì ngoài ở, hoặc cho thuê. Tiền nợ thì mình cũng phải trả, và nó rất nhiều so với tài chính của mình ở thời điểm hiện tại.
  - Tuy  nhiên nếu sang năm, hoặc trong năm nay ông bô chịu sang tên nhà thì oke, mình sẽ thấy vui vẻ trở lại, hehe. Thôi maybe là cứ phiến phiến đi vậy. Mình vẫn sẽ cố khắng giữ kỷ luật trong chuyện chi tiêu và tiết kiệm. Tuần này cũng khá oke, không có giúp em nào, chỉ có massage 2 lần. Kể ra lý tưởng thì 1 tuần mình có thể chỉ tiêu 1tr5-1tr6. 4 tuần là khoảng 6tr. 
  
  ', 'reflection', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-06T06:43:15.512Z'::timestamptz, '2026-06-06T07:01:15.383Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'reflection'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'f2360076-8e2f-4d33-af3d-232b99458e69'::uuid, target_user_id, w.id, m.id, 'Dream Log', 'Dream narrative:
  
  Tôi lại trở về xóm cũ hồi nhỏ. Tôi đứng ngoài cổng căn nhà cũ, thấy bác hàng xóm đi ngang qua, trên người đang mặc quần áo của tôi. Bác đi khá vội, có vẻ không muốn tôi phát hiện ra. Trước đó hình như tôi đã để 1 bọc quần áo ko dùng đến ra sau nhà, trước cổng nhà bác (cũng là nhà cũ hồi tôi còn nhỏ). Sau khi bác đi khỏi, tôi sang nhà bác chơi với mấy anh chị em hàng xóm. Khi bác về thì tôi thấy bác khoác bên ngoài 1 chiếc áo dài che đi chiếc áo bên trong. Tôi không ý kiến gì, vì quần áo đó có vẻ tôi không dùng, chỉ hơi ái ngại thái độ giấu giếm đó.
  Tôi gặp 1 cô bé lạ trong nhóm (không phải là ai trong số hàng xóm bên ngoài đời). Bố mẹ cô bé đi vắng, tôi ở sang nhà chơi với cô bé. (Cô bé làm tôi nhớ đến Ánh Bún, 1 em mập mờ cũ rất xinh). Ban đầu còn ái ngại, nhưng sau đó tôi cởi quần cô bé và chúng tôi làm tình. Có 2 anh em họ của tôi hoặc của cô bé sang chơi, họ chơi ở gian buồng bên cạnh (nhà cô bé lúc này giống hệt nhà tôi, nhưng tôi có cảm giác rất rõ ràng mình là khách). Tôi trùm chăn che đi phần hạ bộ của cả 2 và noí chuyện với họ từ gian chính. Sau đó họ xuống bếp. Tôi và cô bé tiếp tục làm tình. Cô bé có đôi chân và mông rất nhỏ so với hình dung của tôi. Cô nói chugs tôi giống nhau ở chỗ bên trong đều xấu hơn ảnh bên ngoài. Sau đó, bố mẹ cô bé về. Bố cô bé đi vào gian buồng ngang qua gian chính, kì lạ là khi thấy bố mẹ cô bé về, tôi vẫn nhấp chứ không sợ, khi bố cô bé nhìn vào trong tìm cô nói chuyện, tôi mới lấy chăn che lại. Ông hỏi vài câu, sau đó cũng đi. Tôi và cô tiếp tục. Sau đó, bố mẹ cô lại đi, tôi và cô bé mặc đồ, xuống bếp tìm 2 thằng anh em họ thì thấy bọn nó đang ngồi xổm ăn cơm với canh xương khoai tây.
  Chuyển cảnh tôi và mấy thằng đó ngồi học, bọn tôi nói về những đề tài khoa học và triết học, về các thầy cô và những cái cây cao lơn. Thằng bé thì hay hỏi còn thằng lớ có vẻ hiểu biết hơn tôi, khi nó nói đúng và chặt chẽ hơn tôi. Có 1 đoạn tôi tỉnh dậy giữa đêm và nghĩ đến việc hay là mình đi học đại học tiếp. Khúc này khá nhiều suy nghĩ và giải thích nhưng tôi không thể nhớ chính xác.
  
  Sau đó chúng tôi rủ nhau ra cái ao gần đình làng chơi. Ở đó người ta đang tổ chức gì đó, có vẻ như dạy bơi dạy về cái ao. Thầy giáo khá trẻ, cùng thằng đi cùng lúc này là thằng em tôi. Thằng thầy giáo nhảy xuống ước thì bên cạnh xuất hiện tăm cá mập. Mọi người thốt lên lo sợ cho nó, thì thằng em tôi nhanh trí nhảy xuống, nó dùng công phu chạy trên mặt nước đánh lạc hướng con cá mập đuổi theo nó. Sau đó thằng thầy quay lại bắt con cá mập ném lên bờ. Con cá thì chỉ to như con 1 cá trê to. Mợ tôi bán thịt bên cạnh và trêu tôi cùng thằng em. Sau đó, tôi với thằng em đi trên bờ thì thấy nước rút 1 cách bất thường, tôi nghĩ hay là sắp có sóng thần, rồi cảnh báo mọi người tránh xa bờ. Sau vài nhịp nước rút, sóng bắt đầu đến, ban đầu là 1 2 con sóng to hơn bình thường 1 chút. Rồi đến 1 con sống khá cao khoảng 2 3 m. Lúc này tôi đi 1 mình và đã chạy đc một đoạn vài chục m xa đường bờ ao và kênh. tôi thấy sóng trào lên mặt đường chỉ cao đến đầu gối rồi rút đi, để lại 1 quả cầu kim loại màu vàng đôngf to hơn quả bóng đá 1 chút. Có 1 người đàn ông cười khẩy nói tưởng sóng thần như nào, rồi dùng 2 tay định nhấc quả cầu lên. Ngay khi chạm vào, cơ thể anh ta tan biến thành 1 đàn ruồi. Tôi tiếp tục chạy vì nghĩ sẽ có những con sóng cao hơn. Tôi thây ở ruộng lúa bên cạnh (Tất cả đều rất quen thuộc với tuổi thơ tôi), có những con khủng long cổ dài con đang leo cây ăn trínhw khỉ, cách đó không xa có 1 đàn voi, chân dài 4m trông rất đồ sộ đang kiếm ăn giữa ruộng. Ruông lúc này không trồng cây gì mà chỉ có nước nông. Tôi đi qua nhà mợ và biết mợ đã về nhà an toàn. Rồi có 1 con sóng khổng lồ chuẩn bị ập đến. Nhìn từ xa nó phải cao đến 10-15m  Nhưng nó cũng không gây nhiều thiệt hại. Cảnh sau đó tôi không nhớ nhiều.
  Key symbols:
  - 
  
  Emotions:
  
  Jungian reflection:
  ', 'dreams', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-09T01:04:38.603Z'::timestamptz, '2026-06-09T01:32:27.682Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'dreams'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '3a56b190-d0d5-4d3b-abea-04587ede4140'::uuid, target_user_id, w.id, m.id, 'Weekly Spend — 2026-06-08 → 2026-06-14', '{
    "version": 1,
    "weekLabel": "This week",
    "startDate": "2026-06-08",
    "endDate": "2026-06-14",
    "totalBudget": 2000000,
    "categories": [
      {
        "id": "weekly_food",
        "name": "Food",
        "budget": 1500000,
        "spent": 1500000
      },
      {
        "id": "weekly_transport",
        "name": "Transport",
        "budget": 0,
        "spent": 0
      },
      {
        "id": "weekly_social",
        "name": "Social",
        "budget": 500000,
        "spent": 1000000
      },
      {
        "id": "weekly_misc",
        "name": "Misc",
        "budget": 0,
        "spent": 0
      }
    ]
  }', 'weeklySpend', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-13T03:06:09.147Z'::timestamptz, '2026-06-13T03:07:06.664Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'weeklySpend'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'f9345923-7dc9-4128-a513-c12ca13d5ffd'::uuid, target_user_id, w.id, m.id, 'Weekly Reflection', '##  Tuần này có gì?
  - Bị ốm nghỉ mất 2,5 ngày
  - Bị thằng lợn HQ feedback sau khi mình nghỉ ốm 2,5 ngày và thanh niên Lộc move mình khỏi dự án.
  - Cuối tuần thì mình có đỡ ốm và đi tập được bình thường 70-80%
  - Cuối tuần cảm giác hơi thèm sex vì 4 ngày chưa have sex và cũng ko gặp mấy em méng. Biểu hiện là ngồi cafe hay nhìn gái :)). Cũng có thể cảm giác này đến từ việc chưa chinh phục được em hàng xóm nên 1 cách vô thức mình muốn giải toả để prove sth.
  
  ## POV
  Nói chung việc biến động lớn nhất vẫn là ra khỏi dự án. Mình thấy khá thoải mài vì dự án giờ khá hãm, leader thì chán.
  Nhưng some how vẫn thấy hẫng khi dừng giữa chừng, và thấy hơi ngại với anh Trung team lead cũng như đồng nghiệp ở team mình chuyển về (không phải team dự án). Đây chỉ là cảm giác tạm thời. Nhìn chung mình vẫn ổn khi chuyển về team cũ và ngồi chơi như cũ.
  Và mình cũng không còn nhiều sức chịu đựng thêm với LGCNS. Dự kiến hết kỳ đánh giá 20/7 này, lấy tiền bonus xong mình sẽ nghỉ.
  ', 'reflection', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-13T03:07:30.686Z'::timestamptz, '2026-06-13T04:57:01.574Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'reflection'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '0db2e6c3-8f41-4fd1-a8b5-723046513ce0'::uuid, target_user_id, w.id, m.id, 'Weekly Reflection', '### What happend?
  
  This week I moved to my house
  Registered a new gym membership near my house, with the price 13,5m vnd for 27 months. The gym is really good, have space, clean, air cooler, and many diffirents classes for diffirent subjects such as yoga, pilates, bicycle with music, kickboxing, pickle ball,... I think it''s worth the price paid.
  
  Also I have quit the coffee for a week, only order oe in the weekend. I feel sleepy but also feel my body better in some way. I will maintain it next week.
  
  ### Next week
  
  Next week, I will focus on finding a new job. It have to be a remote job.
  And learning new skills: Dev''s technical skills, shopify, content with AI.
  
  There are some things need to be fix in my house, and also my hair, but I will forget about them until I find a way to make my financial good.', 'reflection', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-21T02:43:05.442Z'::timestamptz, '2026-06-21T02:57:56.481Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'reflection'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'c2387014-1eb4-4bc7-a208-ab9f8189a268'::uuid, target_user_id, w.id, m.id, 'Weekly Reflection', '##  What happened this week?
  
  This week, there a little shock that hurt my ego. 
  Thôi nay xin phép nói tiếng Việt để xả hết. Con đồng nghiệp, người trước kia trong team tao quản lý, người mà chả có 1 tí tài năng, chăm chỉ cũng không, iq bình thường, eq thì âm vô cực, chính là cái con có cái vụ về mấy bông hoa héo ấy chatgpt à, mày còn nhớ không?. Ấy thế mà hôm qua, nó được promote lên làm part leader, chức to hơn tao, ngay trong cái team tao từng quản lý. Tao phải thành thật với bản thân, dù tao không thể hiện ra bên ngoài, nhưng ở đây tao đã thực sự không ưa được con này. So thấp kém, ko xứng đang. Tao sẽ đỡ buồn bực hơn nếu người lấp vào vị trí tao để lại đó là 1 đứa em nào đó của tao mà tao nghĩ là xứng đáng hơn, nhưng không, nó là con thấp kém đó :))
  
  Anh đã nghe lời mày, chatgpt à, coi bọn nó là npc, nhưng cái vụ này nó làm anh không thể dửng dưng được.
  Nói đi cũng phải nói lại, ở POV của ông team lead thì trong team đó, sau khi anh đã chuyển đi rồi thì cũng không có ai khả thi khi cần promote hơn con bỏ mẹ đấy.
  Và chủ yếu anh cũng phải tự trách bản thân khi mà chính anh làm việc chểnh mảng để phải rời team sớm. Tuy thế để mà chọn làm part lead với công việc như vậy, với việc chuyển qua 1 part khác với công việc challenge hơn thì anh sẽ chọn phương án 2. Tuy nhiên, khi tính thêm biến cố con của nợ kia được promote thì anh lại không thể chấp nhận được, anh sẽ muốn thà follow cái công việc nhàm chán đó còn hơn là nhìn con của nợ đó được promote.
  
  ## Bài học rút ra:
  
  ###  Ego bị tổn thương
  Việc 1 đứa mình cho là có phẩm chất thấp kém ngồi vào vị trí thuộc về mình, còn bản thân mình phải rời vị trí đó và sang 1 team mới làm tổn thương cái tôi.
  Mình không tức vì bản thân cái chức Part Leader quá ghê gớm, mình tức vì: "Đứa này thật thấp kém, không có 1 phẩm chất nào, từng dưới tao, không xứng đáng, ấy thế mà giờ nó lại hơn tao"
  Nhưng cái cần tỉnh đấy là: "1. Việc nó có vẻ hơn chỉ là tạm thời. 2. Cảm xúc này không chứng minh nó hơn mình, nó chỉ chứng minh 1 việc là mình vẫn còn buộc giá trị của bản thân vào môi trường này".
  Đó là 1 cái bẫy. Khi để 1 môi trường, đặc biệt là môi trường mình không đánh giá cao quyết định giá trị của bản thân. 
  Cái cần chỉnh lại là: 
  ### Giá trị của mình không nằm ở việc ai ngồi ghế part lead, giá trị của mình nằm ở skills, tiêu chuẩn làm việc, khả năng kiếm job ngon hơn, khả năng tự build đường riêng.
  Đó cũng chính là những điều mình cần tập trung cải thiện.
  
  ### Đừng vì cái sự việc nhỏ này mà quay vào cái máng lợn đường đua promote
  
  Nếu vì tổn thương nhất thời này, mà tập trung vào việc cạnh tranh để promote, thì mình đang tỏ ra dễ bị điều khiển, và dễ thay đổi.
  Cách đúng: sự việc này làm mình tỉnh ra, về hệ quả khi làm việc chểnh mảng. Hãy tập trung xây dựng tiêu chuẩn làm việc. Tập trung học hỏi và xây dựng tiếp tục những thứ mình đang xây, đẩy mạnh nó, xây dựng thói quen để sớm có thành quả. Đó sẽ là câu trả lời. 
  Điều duy nhất mình cần khắc phục qua sự vụ này, là tiêu chuẩn làm việc của mình.
  
  ### "Nó được promote không làm anh nhỏ đi. Nhưng phản ứng của anh cho thấy anh vẫn còn để cái team đó có quyền định nghĩa anh."
  
  Đúng thật vậy. Mình còn cảm thấy tệ thì chứng tỏ là mình còn để cho cty này định nghĩa giá trị bản thân.
  Nếu không có 1 chút gợn nào, tức là mình đã đủ mạnh để coi thường mấy thứ này.
  Vẫn là tập trung vào việc của mình để làm mình mạnh lên thôi.
  
  
  ', 'reflection', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-27T02:08:31.286Z'::timestamptz, '2026-06-27T03:06:58.572Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'reflection'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'e36ce97b-a489-4f1c-a080-71d83d034ff8'::uuid, target_user_id, w.id, m.id, 'Shopify niches', 'Pet supply
  Home gym, recover gear
  Sleep optimization
  Men grooming', 'business', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-27T03:15:07.779Z'::timestamptz, '2026-06-27T03:17:40.764Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'business'
  where w.user_id = target_user_id and w.title = 'Business & Investment'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '3b9a9f2b-37d1-42db-a3e3-5fa589e0c35e'::uuid, target_user_id, w.id, m.id, 'Shopify Pet supplier', '', 'business', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-27T03:17:55.193Z'::timestamptz, '2026-06-27T03:18:07.617Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'business'
  where w.user_id = target_user_id and w.title = 'Business & Investment'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'be6a43a4-be01-4292-a78b-d274269663ec'::uuid, target_user_id, w.id, m.id, 'Subscribed credit', '1. ifastnet.com (đã cancel nhưng cần theo dõi)
  2. go daddy (tinypaws.shop)
  3. Github Copillot (đã cancel nhưng vẫn tự renews)
  4. Codex (đang sử dụng)', 'business', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-06-28T02:58:49.291Z'::timestamptz, '2026-06-28T03:02:36.284Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'business'
  where w.user_id = target_user_id and w.title = 'Business & Investment'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '1ba50001-12e9-41a2-ae46-d45ed86fa30a'::uuid, target_user_id, w.id, m.id, 'Weekly Reflection', '## What happened this week?
  - I''m losing direction. Dont know what to priority so that''s a lazy week.
  - I got a new girl. She''s pretty.
  
  ## What to focus/improve next week?
  - I just re-scan all of my todo list and I see It''s too much. The problem, real problem is no focusing. So I need to remove somethings: Shopify building.
  - I will use a new concept - THE ONE THING - the most important thing at one point in time, that need to push all my mind to focus in.
  - For now, THE ONE THING is find a new job.
  - Next week, THE ONE THING is edit cv and apply 10 jobs.', 'reflection', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-07-18T09:44:13.833Z'::timestamptz, '2026-07-18T10:53:59.479Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'reflection'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '4d97d2df-7c7b-46ac-a233-0c8659c1ac40'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '# Capital Dashboard
  
  ## Snapshot
  Date:
  
  Total net worth:
  
  Liquid assets:
  
  Invested capital:
  
  Debt / liabilities:
  
  ## Allocation
  - Cash:
  - Equities:
  - Crypto:
  - Business equity:
  - Real estate:
  - Other:
  
  ## Growth Velocity
  Starting net worth:
  
  Current net worth:
  
  Absolute growth:
  
  Growth rate (%):
  
  Monthly growth speed:
  
  Next milestone:
  
  ## Key Drivers
  What moved the number this period?
  
  ## Decisions
  What should I do next to compound better?
  ', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-07-18T11:15:47.201Z'::timestamptz, '2026-07-18T11:15:47.201Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '67316135-1054-4336-ab0a-937ff8f83c18'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '# Capital Dashboard
  
  ## Snapshot
  Date:
  
  Total net worth:
  
  Liquid assets:
  
  Invested capital:
  
  Debt / liabilities:
  
  ## Allocation
  - Cash:
  - Equities:
  - Crypto:
  - Business equity:
  - Real estate:
  - Other:
  
  ## Growth Velocity
  Starting net worth:
  
  Current net worth:
  
  Absolute growth:
  
  Growth rate (%):
  
  Monthly growth speed:
  
  Next milestone:
  
  ## Key Drivers
  What moved the number this period?
  
  ## Decisions
  What should I do next to compound better?
  ', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-07-18T11:20:10.840Z'::timestamptz, '2026-07-18T11:20:10.840Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'f43a659f-392d-4111-aa1c-6efcca805b70'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '# Capital Dashboard
  
  ## Snapshot
  Date:
  
  Total net worth:
  
  Liquid assets:
  
  Invested capital:
  
  Debt / liabilities:
  
  ## Allocation
  - Cash:
  - Equities:
  - Crypto:
  - Business equity:
  - Real estate:
  - Other:
  
  ## Growth Velocity
  Starting net worth:
  
  Current net worth:
  
  Absolute growth:
  
  Growth rate (%):
  
  Monthly growth speed:
  
  Next milestone:
  
  ## Key Drivers
  What moved the number this period?
  
  ## Decisions
  What should I do next to compound better?
  ', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-07-18T11:21:39.842Z'::timestamptz, '2026-07-18T11:22:32.046Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select 'af3a7cf1-79a8-42d4-a9c5-731ec6c6b37b'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '# Capital Dashboard
  
  ## Snapshot
  Date:
  
  Total net worth:
  
  Liquid assets:
  
  Invested capital:
  
  Debt / liabilities:
  
  ## Allocation
  - Cash:
  - Equities:
  - Crypto:
  - Business equity:
  - Real estate:
  - Other:
  
  ## Growth Velocity
  Starting net worth:
  
  Current net worth:
  
  Absolute growth:
  
  Growth rate (%):
  
  Monthly growth speed:
  
  Next milestone:
  
  ## Key Drivers
  What moved the number this period?
  
  ## Decisions
  What should I do next to compound better?
  ', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-07-18T11:22:21.276Z'::timestamptz, '2026-07-18T11:22:21.276Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '9adc7b5e-513b-4d31-a677-27c907dad226'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '# Capital Dashboard
  
  ## Snapshot
  Date:
  
  Total net worth:
  
  Liquid assets:
  
  Invested capital:
  
  Debt / liabilities:
  
  ## Allocation
  - Cash:
  - Equities:
  - Crypto:
  - Business equity:
  - Real estate:
  - Other:
  
  ## Growth Velocity
  Starting net worth:
  
  Current net worth:
  
  Absolute growth:
  
  Growth rate (%):
  
  Monthly growth speed:
  
  Next milestone:
  
  ## Key Drivers
  What moved the number this period?
  
  ## Decisions
  What should I do next to compound better?
  ', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-07-18T11:27:06.895Z'::timestamptz, '2026-07-18T11:27:06.895Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '93004776-b3f1-49b7-a621-728a45a08bbf'::uuid, target_user_id, w.id, m.id, 'The One Thing — Week of Jul 19, 2026', '## Monthly direction
  What is the most important result I want this month?
  
  Why does this matter now?
  
  ## This week''s one thing
  What is the ONE thing I can do this week such that by doing it everything else will be easier or unnecessary?
  
  What does a successful week look like in concrete terms?
  
  ## Focus and tradeoffs
  What will I say no to so this gets my best attention?
  
  What is the biggest obstacle, and how will I handle it?
  
  ## First move
  What is the smallest meaningful action I will take first?
  
  When will I do it?
  
  ## End-of-week check
  Did I complete the one thing? What did I learn?
  ', 'oneThing', array(select jsonb_array_elements_text('["the-one-thing","week:2026-07-19"]'::jsonb)), false, false, '2026-07-18T17:50:52.953Z'::timestamptz, '2026-07-18T17:50:52.953Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'oneThing'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '40e2d0bd-23ed-47cd-a888-6270c5e4a8ab'::uuid, target_user_id, w.id, m.id, 'The One Thing — Week of Jul 19, 2026', '## Monthly direction
  What is the most important result I want this month?
  
  Why does this matter now?
  
  ## This week''s one thing
  What is the ONE thing I can do this week such that by doing it everything else will be easier or unnecessary?
  
  What does a successful week look like in concrete terms?
  
  ## Focus and tradeoffs
  What will I say no to so this gets my best attention?
  
  What is the biggest obstacle, and how will I handle it?
  
  ## First move
  What is the smallest meaningful action I will take first?
  
  When will I do it?
  
  ## End-of-week check
  Did I complete the one thing? What did I learn?
  ', 'oneThing', array(select jsonb_array_elements_text('["the-one-thing","week:2026-07-19"]'::jsonb)), false, false, '2026-07-19T08:09:36.536Z'::timestamptz, '2026-07-19T08:09:36.536Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'oneThing'
  where w.user_id = target_user_id and w.title = 'Reflect'
  on conflict (id) do nothing;
  
  insert into public.notes (id, user_id, workspace_id, menu_id, title, content, type, tags, pinned, archived, created_at, updated_at)
  select '4359e897-df23-4947-af7a-c1449008f9c6'::uuid, target_user_id, w.id, m.id, 'Capital Dashboard', '# Capital Dashboard
  
  ## Snapshot
  Date:
  
  Total net worth:
  
  Liquid assets:
  
  Invested capital:
  
  Debt / liabilities:
  
  ## Allocation
  - Cash:
  - Equities:
  - Crypto:
  - Business equity:
  - Real estate:
  - Other:
  
  ## Growth Velocity
  Starting net worth:
  
  Current net worth:
  
  Absolute growth:
  
  Growth rate (%):
  
  Monthly growth speed:
  
  Next milestone:
  
  ## Key Drivers
  What moved the number this period?
  
  ## Decisions
  What should I do next to compound better?
  ', 'capital', array(select jsonb_array_elements_text('[]'::jsonb)), false, false, '2026-07-19T08:09:36.538Z'::timestamptz, '2026-07-19T08:09:36.538Z'::timestamptz
  from public.workspaces w
  join public.menus m on m.workspace_id = w.id and m.type = 'capital'
  where w.user_id = target_user_id and w.title = 'Cash Flow'
  on conflict (id) do nothing;
end $$;

commit;
