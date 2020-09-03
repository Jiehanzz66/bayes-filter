t=0.01:0.01:1;
x=zeros(1,100);
y=zeros(1,100);
x(1)=0.1;
y(1)=0.01^2;
for i=2:100
    x(i)=sin(x(i-1))+5*x(i-1)/(x(i-1)^2+1);
    y(i)=x(i)^2+normrnd(0,1);
end

n=100;
xold=zeros(1,n);
xnew=zeros(1,n);
xplus=zeros(1,100);%存放滤波结果
w=zeros(1,n);
for i=1:n
    xold(i)=0.1;
    w(i)=1/n;
end

for i=2:n
    %预测步
    for j=1:n
        xold(j)=sin(xold(j))+5*xold(j)/(xold(j)^2+1)+normrnd(0,0.1);%Q
    end
    %更新步
    for j=1:n
        %w(j)=w(j)*fR(.....)
        %fR=(2*Pi*R)^(-0.5)*exp(-((y(i)-xold(j)^2)/(2*R)));
        w(j)=exp(-((y(i)-xold(j)^2)/(2*0.1)));%R
    end
    %归一化
    w=w/sum(w);
    %w/sum(w)等价于kw/sun(kw),(2*Pi*R)^(-0.5)也是常数
    %每次重采样，w（j）都会设为1/n，也为常数，可省去
    %若不是每次重采样，需要加上w（j）
    %N<1/sum(wi^2)
    %生成c
    c=zeros(1,n);
    c(1)=w(1);
    for j=2:n
        c(j)=c(j-1)+w(j);
    end
    for j=1:n
        a=unifrnd(0,1);%均匀分布
       for k=1:n
           if(a<c(k))
               xnew(j)=xold(k);
               break;%一定要break，不然粒子会被最后一个覆盖
           end
       end
    end
    %重采样完成
    %把新粒子赋值给xold
    xold=xnew;
    for j=1:n
        w(j)=1/n;
    end
    %把每一步的后验概率期望赋值xplus
    xplus(i)=sum(xnew)/n;
end


plot(t,x,'r',t,xplus,'b','LineWidth',2)