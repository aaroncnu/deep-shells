function [normal,normalf,flip] = compute_normal(vertex,face,flip)
% compute_normal - compute the normal of a triangulation

[vertex,face] = check_face_vertex(vertex,face);

nface = size(face,2);
nvert = size(vertex,2);

% unit normals to the faces
normalf = crossp( vertex(:,face(2,:))-vertex(:,face(1,:)), ...
                  vertex(:,face(3,:))-vertex(:,face(1,:)) );
d = sqrt( sum(normalf.^2,1) ); d(d<eps)=1;
normalf = normalf ./ repmat( d, 3,1 );

% unit normal to the vertex
normal = zeros(3,nvert);
for i=1:nface
    f = face(:,i);
    for j=1:3
        normal(:,f(j)) = normal(:,f(j)) + normalf(:,i);
    end
end
% normalize
d = sqrt( sum(normal.^2,1) ); d(d<eps)=1;
normal = normal ./ repmat( d, 3,1 );

% enforce that the normal are outward
v = vertex - repmat(mean(vertex,2), 1,nvert);
s = sum( v.*normal, 2 );

flip = (exist('flip','var') && flip) || (~(exist('flip','var')) && sum(s>0)<sum(s<0));
if flip
    % flip
    normal = -normal;
    normalf = -normalf;
end



function z = crossp(x,y)
% x and y are (m,3) dimensional
z = x;
z(1,:) = x(2,:).*y(3,:) - x(3,:).*y(2,:);
z(2,:) = x(3,:).*y(1,:) - x(1,:).*y(3,:);
z(3,:) = x(1,:).*y(2,:) - x(2,:).*y(1,:);