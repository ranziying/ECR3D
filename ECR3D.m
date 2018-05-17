%����3D�ռ���ECR�ŵ�Ĺ��̣�����ΪPIC-MCC

clear variables;
clc;

global m_e q_e m_H q_H

%�����������
m_e=9.109e-31; %��������
q_e=-1.602e-19; %���ӵ���
AMU = 1.661e-27; %������������λ��kg
EPS0 = 8.854e-12; %����еĽ�糣������λ��F/m
MU0=4*pi()*1e-7; %����еĴŵ��ʣ���λ��H/m
k=1.38e-23; %����������������λ��J/K
c=3e8; %���٣���λ��m/s
E_H=13.6; %��ĵ�����
m_H=1*AMU; %��������
q_H=1.602e-19; %���ӵ���
Z=0.042; %Z�᷶Χ
R=0.02; %�ŵ��Ұ뾶
P=1; %����Դ�ڵ�ѹǿ����Ϊ1Pa
V=pi()*R^2*Z; %����Դ�ŵ��ҵ����
T=273.15+300; %Դ�ڵ��¶���Ϊ300��
n=P/k/T; %Դ������ԭ�ӵ����ܶȣ������������巽��P=nkT�ó�
dt_e=1.5e-12; %�����˶�ʱ�䲽��
dt_i=3.0e-10; %�����˶�ʱ�䲽��
dg=0.0005; %��Ԫ����ĳ��ȣ���λ��m
step_num_i=600; %���ӵ�ʱ�䲽��
N_grid_x=(0.02-(-0.02))/0.0005+1; %x����ĸ����
N_grid_y=(0.02-(-0.02))/0.0005+1; %y����ĸ����
N_grid_z=(0.063-0)/0.0005+1; %z����ĸ����
spwt_e=1e6; %ÿ�������Ӵ�����ʵ�ʵ��Ӹ���
spwt_i=1e3; %ÿ�������Ӵ�����ʵ�����Ӹ���
N_e=1000; %��ʼ������ĿΪ1000��
N_i=1; %��ʼ������ĿΪ1��
vth_e=c^2-(c/(-q_e*0.01/m_e/c^2+1)^2);  %���ӵ����ٶȣ���Ϊ2 eV
B_x=zeros(N_grid_x,N_grid_y,N_grid_z); %����ϵ�BxԤ����ռ�
B_y=zeros(N_grid_x,N_grid_y,N_grid_z); %����ϵ�ByԤ����ռ�
B_z=zeros(N_grid_x,N_grid_y,N_grid_z); %����ϵ�BzԤ����ռ�
E_x=zeros(N_grid_x,N_grid_y,N_grid_z); %����ϵ�ExԤ����ռ�
E_y=zeros(N_grid_x,N_grid_y,N_grid_z); %����ϵ�EyԤ����ռ�
E_z=zeros(N_grid_x,N_grid_y,N_grid_z); %����ϵ�EzԤ����ռ�
B_e=zeros(N_e,3); %��������λ�ô��ĴŸ�Ӧǿ��
B_i=zeros(N_i,3); %��������λ�ô��ĴŸ�Ӧǿ��
E_e=zeros(N_e,3); %��������λ�ô��ĵ糡ǿ��
E_i=zeros(N_i,3); %��������λ�ô��ĵ糡ǿ��
%pos_e=zeros(N_e,3); %�����ӵ�λ��Ԥ����ռ�
%vel_e=zeros(N_e,3); %�����ӵ��ٶ�Ԥ����ռ�
pos_i=zeros(N_i,3); %�����ӵ�λ��Ԥ����ռ�
vel_i=zeros(N_i,3); %�����ӵ��ٶ�Ԥ����ռ�

load magnetic.txt; %����ų�����
load sigma.txt; %��������������
len_B=length(magnetic); %ȷ���ų����ݵ�����
len_s=length(sigma); %ȷ������������ݵ�����

%���ų����ݶ����䵽�����
for i=1:len_B
    in_x=(magnetic(i,1)-(-0.02))/0.0005+1; %x��������ĸ�����
    in_x=round(in_x); %ȡ��
    in_y=(magnetic(i,2)-(-0.02))/0.0005+1; %y��������ĸ�����
    in_y=round(in_y); %ȡ��
    in_z=(magnetic(i,3)-0)/0.0005+1; %z��������ĸ�����
    in_z=round(in_z); %ȡ��
    B_x(in_x,in_y,in_z)=magnetic(i,4); %��x����ĴŸ�Ӧǿ�ȷ��䵽������
    B_y(in_x,in_y,in_z)=magnetic(i,5); %��y����ĴŸ�Ӧǿ�ȷ��䵽������
    B_z(in_x,in_y,in_z)=magnetic(i,6); %��z����ĴŸ�Ӧǿ�ȷ��䵽������
    fprintf('there is %d data left to load, please be patient\n', len_B-i);
end
fprintf('Congratulations! All the magnetic data has been loaded!\n');


%�������ӵĳ��ٶȺͳ�λ��
vel_e=sampleIsotropicVel(vth_e,N_e); %�����Ӻ�����ÿ�����ӷ���������˹Τ�ֲ�����4�нǶȸ���ͬ�Ե��ٶ�
theta_pos_e=2*pi()*rand(N_e,1); %ѡ��һ������Ƕ�
R_e=R*rand(N_e,1); %���ӵľ���λ��
pos_e=[R_e.*cos(theta_pos_e),R.*sin(theta_pos_e),Z*rand(N_e,1)+0.011]; %�ŵ��ҵİ뾶ΪR������Ϊ0.042m

%��ʼ��ѭ��
for ts_i=1:step_num_i
    for ts_e=1:dt_i/dt_e %�����˶�һ���������˶�dt_i/dt_e��
        
        %���ȸ���MCC�ж��Ƿ�����ײ
        sigma_e=zeros(N_e,1); %��������λ�ô���������Ľ���
        Ek_e=m_e*c^2*(1./sqrt(1-sum(((vel_e/c).^2)'))-1)/(-q_e); %��������۶��ܷ���������е��ӵĶ��ܣ���λΪeV
        Ek_e=Ek_e'; %�����ܾ����������ת������ΪN_e�С�1��
        
        
        %p=1; %���ڱ���ÿ������
        
        for p=1:N_e %����ÿ������
            for cross=1:len_s
                if Ek_e(p,1)<sigma(1,1)
                    sigma_e(p,1)=0;
                    break;
                end
                if sigma(cross,1)<=Ek_e(p,1) && cross<len_s
                    sigma_e(p,1)=1e-6*((sigma(cross+1,2)-sigma(cross,2))/(sigma(cross+1,1)-sigma(cross,1))*(Ek_e(p,1)-sigma(cross,1))+sigma(cross,2)); %ͨ����ֵ�ķ�ʽ�ҵ�������������Ӧ�ĵ������
                    P_e=1-exp(-n*sigma_e(p,1)*dt_e); %����õ��ӷ�������ĸ���
                    R_e=rand(); %��ȡһ����������Ժ͵���������Ƚ�
                    if R_e<P_e %������ײ����
                        f_s=rand(); %����һ���������Ϊ���������ĵ����ܺ�����ɢ����ӵı���
                        Ek_e_s=(Ek_e(p,1)-E_H)*fs; %��ײ��ɢ����ӵ�����
                        Ek_e_n=(Ek_e(p,1)-E_H)*(1-fs); %��ײ��������µ��ӵ�����
                        N_e=N_e+1; %����������ײ������һ������
                        N_i=N_i+1; %����������ײ������һ������
                        Ek_e(p,1)=Ek_e_s; %��ɢ�����ӵ���������ԭ�������
                        Ek_e=[Ek_e;Ek_e_n]; %���²����ĵ��ӵ�������ֵ�����һ������
                        v_s2=c^2-(c/(-q_e*Ek_e(p,1)/m_e/c^2+1)^2); %ɢ������ٶȵ�ƽ��
                        v_n2=c^2-(c/(-q_e*Ek_e(p,1)/m_e/c^2+1)^2); %�²����ĵ����ٶȵ�ƽ��
                        [v_s_2,~]=randfixedsum(3,1,v_s2,0,v_s2); %��ɢ������ٶȵ�ƽ���ֽ��x��y��z�����ٶȵ�ƽ����
                        [v_n_2,ignore]=randfixedsum(3,1,v_n2,0,v_n2); %���²����ĵ����ٶȵ�ƽ���ֽ�Ϊx��y��z�����ٶȵ�ƽ����
                        v_s=randomV(v_s_2); %ɢ�������x��y��z����ķ���
                        v_n=randomV(v_n_2); %�²����ĵ�����x��y��z����ķ���
                        vel_e(p,:)=v_s'; %��ɢ����ӵ��ٶȷ���������ٶȵľ���
                        vel_e(N_e,:)=v_n'; %���������µ��ӵ��ٶȷ���������ٶȵľ���
                        pos_e(N_e,:)=pos_e(p,:); %�²����ĵ��ӵ�λ�������������ͬ
                        v_i_n=randraw('maxwell',k*T/m_H,1); %���ɷ������˹Τ���ʷֲ��������ӵ�����
                        [v_i_v,ignore]=randfixedsum(3,1,v_i_n^2,0,v_i_n^2); %�������������ٶȵ�ƽ���ֽ�Ϊx��y��z�����ٶȵ�ƽ��
                        v_i=randomV(v_i_v); %�������ɵ�������ƽ����
                        vel_i(N_i,:)=v_i'; %�������ɵ����ӵ��ٶȷ���������ٶȵľ���
                        pos_i(N_i,:)=pos_e(p,:);%�²��������ӵ�λ�������������ͬ
                        %p=p+1; %������һ������
                    end
                    break;
                end
                if sigma(cross,1)<=Ek_e(p,1)&&cross==len_s
                    sigma_e(p,1)=1e-6*((0-sigma(cross,2))/(0-sigma(cross,1))*(Ek_e(p,1)-sigma(cross,1))+sigma(cross,2)); %��ֵ�ҽ���
                    P_e=1-exp(-n*sigma_e(p,1)*dt_e); %����õ��ӷ�������ĸ���
                    R_e=rand(); %��ȡһ����������Ժ͵���������Ƚ�
                    if R_e<P_e %������ײ����
                        f_s=rand(); %����һ���������Ϊ���������ĵ����ܺ�����ɢ����ӵı���
                        Ek_e_s=(Ek_e(p,1)-E_H)*fs; %��ײ��ɢ����ӵ�����
                        Ek_e_n=(Ek_e(p,1)-E_H)*(1-fs); %��ײ��������µ��ӵ�����
                        N_e=N_e+1; %����������ײ������һ������
                        N_i=N_i+1; %����������ײ������һ������
                        Ek_e(p,1)=Ek_e_s; %��ɢ�����ӵ���������ԭ�������
                        Ek_e=[Ek_e;Ek_e_n]; %���²����ĵ��ӵ�������ֵ�����һ������
                        v_s2=c^2-(c/(-q_e*Ek_e(p,1)/m_e/c^2+1)^2); %ɢ������ٶȵ�ƽ��
                        v_n2=c^2-(c/(-q_e*Ek_e(p,1)/m_e/c^2+1)^2); %�²����ĵ����ٶȵ�ƽ��
                        [v_s_2,ignore]=randfixedsum(3,1,v_s2,0,v_s2); %��ɢ������ٶȵ�ƽ���ֽ��x��y��z�����ٶȵ�ƽ����
                        [v_n_2,ignore]=randfixedsum(3,1,v_n2,0,v_n2); %���²����ĵ����ٶȵ�ƽ���ֽ�Ϊx��y��z�����ٶȵ�ƽ����
                        v_s=randomV(v_s_2); %ɢ�������x��y��z����ķ���
                        v_n=randomV(v_n_2); %�²����ĵ�����x��y��z����ķ���
                        vel_e(p,:)=v_s'; %��ɢ����ӵ��ٶȷ���������ٶȵľ���
                        vel_e(N_e,:)=v_n'; %���������µ��ӵ��ٶȷ���������ٶȵľ���
                        pos_e(N_e,:)=pos_e(p,:); %�²����ĵ��ӵ�λ�������������ͬ
                        v_i_n=randraw('maxwell',k*T/m_H,1); %���ɷ������˹Τ���ʷֲ��������ӵ�����
                        [v_i_v,ignore]=randfixedsum(3,1,v_i_n^2,0,v_i_n^2); %�������������ٶȵ�ƽ���ֽ�Ϊx��y��z�����ٶȵ�ƽ��
                        v_i=randomV(v_i_v); %�������ɵ�������ƽ����
                        vel_i(N_i,:)=v_i'; %�������ɵ����ӵ��ٶȷ���������ٶȵľ���
                        pos_i(N_i,:)=pos_e(p,:);%�²��������ӵ�λ�������������ͬ
                    end
                end
            end
        end
        
        
        
        
        
        
        
        
        
        
        
        
    end
end
        
        
        
        
        
        
        
        