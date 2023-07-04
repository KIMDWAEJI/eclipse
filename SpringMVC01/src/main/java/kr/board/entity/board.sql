create table myboard(
	idx int not null auto_increment,
	title varchar(100) not null,
	content varchar(2000) not null,
	writer varchar(30) not null,
	indate datetime default now(),
	count int default 0,
	primary key(idx)
);

insert into myboard(title,content,writer)
values('test-1','test1','test01');
insert into myboard(title,content,writer)
values('test-2','test2','test02');
insert into myboard(title,content,writer)
values('test-3','test3','test03');

select * from myboard order by idx desc;