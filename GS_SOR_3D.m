%****************************************************************
%���Ӻ����ø�˹-���¶��ӳ��ɳڵ����ķ��������ά�ռ��еĵ���%
%****************************************************************

function phi = GS_SOR_3D(rho,nx,ny,nz,tol,w,choice)
%***************************************************************
%rho�������ÿ������ϵĵ���ܶȣ�
%nx�������ϵͳx����ĸ��������
%ny�������ϵͳy����ĸ��������
%nz�������ϵͳz����ĸ��������
%tol������ǵ���������ݲ
%w��������ɳ�����
%choice��ȡֵΪ1��2��
%          choice=1����ʾ�����߽�ĵ���Ϊ0
%          choice=2����ʾ�����߽�ĵ��ƶ������һ�׵���Ϊ0
%***************************************************************
global dg EPS0    %����ȫ�ֱ���
solver_it = 20000;  %��������
phi = zeros(nx,ny,nz);  %�����Ƹ���ֵ
%**********************choice = 1*******************************
if choice == 1
    for i = 1:solver_it
        g = 1/6*((rho(2:nx-1,2:ny-1,2:nz-1)/EPS0)*dg*dg+phi(3:nx,2:ny-1,2:nz-1)+phi(1:nx-2,2:ny-1,2:nz-1)+...
            phi(2:nx-1,3:ny,2:nz-1)+phi(2:nx-1,1:ny-2,2:nz-1)+phi(2:nx-1,2:ny-1,3:nz)+phi(2:nx-1,2:ny-1,1:nz-2));   %ֻ���2��nz-1�ĵ���ֵ�������ǲ��ɷ���
        phi(2:nx-1,2:ny-1,2:nz-1) = phi(2:nx-1,2:ny-1,2:nz-1)+w*(g-phi(2:nx-1,2:ny-1,2:nz-1));                %�����ɳڵ���
        if mod(i,25) == 0
            res = rho(2:nx-1,2:ny-1,2:nz-1)/EPS0+(phi(3:nx,2:ny-1,2:nz-1)+phi(1:nx-2,2:ny-1,2:nz-1)+...
            phi(2:nx-1,3:ny,2:nz-1)+phi(2:nx-1,1:ny-2,2:nz-1)+phi(2:nx-1,2:ny-1,3:nz)+phi(2:nx-1,2:ny-1,1:nz-2)-6*phi(2:nx-1,2:ny-1,2:nz-1))/(dg*dg); %��������Ĳв�
            sum_res = sum(sum(sum(res.^2)));          %������вв�ĺ�
            judge = sqrt(sum_res/(nx*ny*nz));       %���ƽ���в�
            fprintf('It is the %d interp\tThe residual is %g\n',i,judge);
            if judge < tol                  %��ƽ���в����趨�ݲ���жԱȣ�������в�Ҫ����ֹͣѭ��
                break;
            end
        end
%         fprintf('It is the %d interp\n',i);
    end
    clc;
    if i == solver_it
        fprintf('The interation is not converged!!!\n');
    end
end

%**********************choice = 2*******************************
if choice == 2
    for i = 1:solver_it
        g = 1/6*((rho(2:nx-1,2:ny-1,2:nz-1)/EPS0)*dg*dg+phi(3:nx,2:ny-1,2:nz-1)+phi(1:nx-2,2:ny-1,2:nz-1)+...
            phi(2:nx-1,3:ny,2:nz-1)+phi(2:nx-1,1:ny-2,2:nz-1)+phi(2:nx-1,2:ny-1,3:nz)+phi(2:nx-1,2:ny-1,1:nz-2));   %ֻ���2��nz-1�ĵ���ֵ�������ǲ��ɷ���
        phi(2:nx-1,2:ny-1,2:nz-1) = phi(2:nx-1,2:ny-1,2:nz-1)+w*(g-phi(2:nx-1,2:ny-1,2:nz-1));                %�����ɳڵ���
        phi(1,:,:) = phi(2,:,:);                                              %��߽�ĵ���
        phi(nx,:,:) = phi(nx-1,:,:);                                          %�ұ߽�ĵ���
        phi(:,1,:) = phi(:,2,:);
        phi(:,ny,:) = phi(:,ny-1,:);
        phi(:,:,1) = phi(:,:,2);
        phi(:,:,nz) = phi(:,:,nz-1);
        if mod(i,25) == 0
            res = rho(2:nx-1,2:ny-1,2:nz-1)/EPS0+(phi(3:nx,2:ny-1,2:nz-1)+phi(1:nx-2,2:ny-1,2:nz-1)+...
            phi(2:nx-1,3:ny,2:nz-1)+phi(2:nx-1,1:ny-2,2:nz-1)+phi(2:nx-1,2:ny-1,3:nz)+phi(2:nx-1,2:ny-1,1:nz-2))/(dg*dg); %��������Ĳв�
            sum_res = sum(sum(sum(res.^2)));          %������вв�ĺ�
            judge = sqrt(sum_res/(nx*ny*nz));       %���ƽ���в�
            if judge < tol                  %��ƽ���в����趨�ݲ���жԱȣ�������в�Ҫ����ֹͣѭ��
                break;
            end
        end
    end
    if i == solver_it
        fprintf('The interation is not converged!!!\n');
    end
end
        

