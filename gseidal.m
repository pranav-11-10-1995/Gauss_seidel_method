clc;   
      %s.no from to imped   admit(1/2 line)
data=[ 1    1   2   0.4i   0.00i;
       2    2   3   0.2i   0.00i;
       3    3   1   0.3i   0.00i;];
   y=zeros(3,3);% returns n*n matrix of zeros
   len=length(data(:,1)); % length finds no. of elements in a list
for i=1:len
   for j=1:len
        m=data(i,2);
        n=data(j,3);
        if(m==n)% m=n -> compares elements in 2nd & 3rd columns
        y(m,n)= 1/data(i,4)+1/data(j,4)+data(i,5)+data(j,5);
        elseif(i==j)% i=j -> compares the elements in same row
        y(m,n)=-1/data(i,4);
        else
        y(m,n)=y(n,m);% since y(1,2),y(2,3) occur before y(2,1) & y(3,2)
       end
   end
 end
y(n,m)=y(m,n);% since y(1,3) occurs before y(3,1) ie., y(3,1) -> y(1,3)
disp('          FORMING Y BUS')
y 
        %s       %v      delta         P        Q     qlow   qup
data1=[  1      1.05         0         0        0       0     0;    %slack bus
         2      1.02         0         0.3      0     -10   100;    %pv bus(p & q specified denote generator powers)
         3      1            0        -0.4    -0.2i     0     0;  ];%pq bus(p & q specified denote load powers)
     disp('          FOR PV BUS, FINDING Q & DELTA') 
 for i=1:3
 if((data1(i,2)~=1) && (data1(i,4)~=0))% selecting pv bus ->2nd column~=1 & 4th column ~= 0
     k=0;
     v=data1(i,2);% v=1.02
     p=data1(i,4);% p=0.3
     s=data1(i,1);% s=2
     qlow=data1(i,6); %qlow=-10
     qup=data1(i,7); %qup=100
     for j=1:3
     k=k+data1(j,s)*y(s,j); %s=2 ...recursion  concept is employed
     end
     k;%k=|v1|*|y21|+|v2|*|y22|+|v3|*|y23|
     q=-k*v
       disp('        Q-LIMIT CHECK:')
     if(q>qlow && q<qup)
         disp('                          ')
         disp('        Q IS WITHIN LIMITS')
     else
         disp('q  limits hit')
     end
     k=0;
     for j=1:3
         if(j~=s)
         k=k+data1(j,s)*y(s,j);
         end
     end
    k;%k=|v1|*|y21|+|v3|*|y23|
    store=data1(2,2);%store=1.02
    sub=1;
    vnew=data1(2,2); %vnew=1.02   
    while(sub>(0.0001))
%since complex no. can't be compared,i'm taking only magnitude for comparison
      for j=1:3 
       if(j==s)      %j=s=2
         vnew=(((p-q)/vnew)-k)*(1/y(s,j));
         realv=real(vnew);
         imagv=imag(vnew);
       end
       end
       vmag=sqrt(realv^2+imagv^2);
       delta=atand(imagv/realv) 
       sub=vmag-store;
       store=vmag;
     end
   end
 end
 data1(2,2)=vnew;% v2 is updated from 1.02 to 1.02+0.04i
 data1;
    disp('          FOR PQ BUS, FINDING V & DELTA')
  store=data1(3,2);%store=1
  sub=1;
  vnew=data1(3,2); %vnew=1
 while(sub>(0.00001))
  for i=1:3
   if((data1(i,4)~=0) && (data1(i,5)~=0))% selecting pq bus ->4th column~=0 & 5th column ~= 0
    p=data1(i,4);
    q=data1(i,5);
    v=data1(i,2);
    s=data1(i,1);%s=3
    k=0;
       for j=1:3
         if(j~=s)%j=1,2
         k=k+data1(j,s-1)*y(s,j);
         end
       end
         k;%k=|v1|*|y31|+|v2|*|y32|
       for j=1:3 
         if(j==s)  %j=s=3  
         vnew=(((p-q)/vnew)-k)*(1/y(s,j));
         realv=real(vnew);
         imagv=imag(vnew);
         end
       end
       vmag=sqrt(realv^2+imagv^2)
       delta=atand(imagv/realv)
       sub=vmag-store;
       store=vmag;
    end
   end
 end