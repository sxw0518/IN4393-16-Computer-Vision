function Dis = SampsonDist(p1,p2,F)
a=F*p1';
b=F'*p2';
Dis = (p2*F*p1')^2/(a(1)^2+a(2)^2+b(1)^2+b(2)^2);
end
