% Manushka Vaidya : Coil packing by importing coordinates from Sloane's website.
% Radius and coordinates obtained from website: NeilSloane.com/packings/
% N. J. A. Sloane, with the collaboration of R. H. Hardin, W. D. Smith and others, Tables of Spherical Codes, published electronically at NeilSloane.com/packings/

plot_coil_number_flag=1;
sphereradius=.1;
current_radius=0.1342;

% covering_radius=74.8584922/2;
% packing_radius=63.4349488/2;
packing_radius=23.0517306/2;  % use the min. seperation in degrees on the website corresponding to the number of points of interest. 

% for coordinates, open the respective page with the coordinates
% corresponding to the number of points of interest.
coordinates=[-9.140305605060887700e-01
 -2.052641850338791700e-01
  3.498781913799468000e-01
 -5.448901465968492000e-01
  7.943064205297200000e-01
  2.686485407496714800e-01
 -8.544905183012105900e-01
  1.629735238547983500e-01
  4.932398855077294000e-01
 -8.803051490048224800e-01
  4.322735788553011500e-01
  1.954543365065793400e-01
 -5.780912541242950700e-01
  4.771477615887147900e-02
 -8.145758417981156000e-01
  9.330109263713562400e-02
  9.955759370074223100e-01
  1.111124495769159500e-02
 -6.707964877768445300e-01
 -7.415577274630208400e-01
 -1.114490135128974300e-02
  3.099726945223507700e-02
 -2.286073685291536200e-01
 -9.730250974875630500e-01
  5.457372159615980800e-01
  6.516767116011700200e-01
 -5.267716342696992000e-01
  9.561578238073922300e-01
  2.839366863272515500e-01
 -7.170895431821647200e-02
  5.540223402136391600e-01
  1.718042618941124100e-01
  8.145812065958936100e-01
 -3.574317989241996300e-01
 -2.763089334377413200e-01
 -8.921299694665058000e-01
 -2.205941331651275800e-01
  7.248251821886889700e-01
 -6.526612319406291900e-01
 -6.975234164953918500e-01
  5.196982415358492000e-01
 -4.933303367776428200e-01
 -5.173306397200934100e-01
 -5.534619968798149000e-01
 -6.527241585973411200e-01
 -4.457126314799073600e-01
  4.238672942239431500e-01
 -7.884648166066318100e-01
  7.988734140234909900e-01
  3.442788297685310800e-01
 -4.932274888321441200e-01
  8.155426109310720500e-01
 -5.785903205404006000e-01
  1.111263842148867800e-02
  6.576592307122963700e-02
 -9.785006314069449900e-01
  1.954772562187200300e-01
 -4.557515138563051900e-01
 -6.544523980889900300e-01
  6.033097183480937700e-01
 -3.389453606086378400e-01
  7.218513769083738700e-01
  6.033627699629514600e-01
 -1.116133030446660900e-01
 -8.426312715988145700e-01
  5.267969349827544800e-01
 -8.371651020009868200e-01
  1.467764456292972000e-01
 -5.268882870211745200e-01
  6.347313921767372400e-01
 -6.889366170685189400e-01
  3.499748525931054000e-01
  1.826143041924338000e-01
  1.411342663374017000e-01
 -9.730021247508746600e-01
  5.829957691156131800e-02
  7.553722626260521700e-01
  6.526974062972299400e-01
 -6.137143466572324600e-01
  4.213424690406469100e-02
  7.884030732721135600e-01
 -9.135008527859083100e-01
  3.567532994190256700e-01
 -1.955588794022339300e-01
 -7.686407833075574700e-01
 -5.403967262808038200e-01
 -3.422904095374778600e-01
  2.915425155823326300e-01
 -7.984019632416156100e-01
 -5.268370399847178700e-01
  1.927959932348365400e-02
 -2.299396980701286500e-01
  9.730138911142759400e-01
  3.304335995237799900e-01
  4.768750616978629200e-01
 -8.144960477721287000e-01
  1.478197620580903000e-01
 -9.694943764076090500e-01
 -1.955248630203094100e-01
 -1.211294527623272700e-01
  9.317727340802997000e-01
  3.422385537867153600e-01
  5.867291815730820700e-01
 -5.401213051673552400e-01
 -6.033389123824967100e-01
 -6.834106689502595900e-01
 -3.271879314235325300e-01
  6.526085466002943300e-01
  2.478348833377417300e-01
 -5.245106868301764300e-01
 -8.145344744097112700e-01
 -1.441156340340334400e-01
 -5.979433236326067200e-01
 -7.884760400609269700e-01
  5.939144367021345100e-01
 -7.583509343191634500e-01
 -2.686438205022366700e-01
  1.744767444420491400e-01
  7.781744466420161800e-01
 -6.033261110231313800e-01
  2.860385453050998700e-01
 -8.214902426063547300e-01
  4.932907174296867200e-01
 -7.464209598900208900e-01
 -5.707826808802336500e-01
  3.421445335586018000e-01
 -4.703726205678144800e-01
 -8.100873759994611200e-01
 -3.500114870493177800e-01
 -2.133998614431549000e-01
  8.756765366431135100e-02
 -9.730325817606364500e-01
  7.380667822354899400e-01
 -1.712997633941749100e-01
 -6.526207290775015700e-01
 -9.536866981193460300e-01
 -1.351395939831374600e-01
 -2.687358777094943600e-01
  8.523645152627570300e-01
 -3.954689518134996700e-01
 -3.421681476590379700e-01
  6.249690826884295400e-01
 -4.282477531172193500e-01
  6.527001667179472800e-01
  7.657236290344260300e-01
  6.127600747577307500e-01
 -1.954287970623804800e-01
 -3.068086925100322300e-01
  9.517068990639486700e-01
 -1.106365556077723400e-02
  8.144966876269846800e-01
  5.462080547824969000e-01
  1.955809467596247600e-01
  9.776075894114505400e-01
 -2.101480956767516900e-01
 -1.100813374589984500e-02
  5.581025430546905400e-01
  8.266549739083637300e-01
  7.185475313749292700e-02
 -6.050262882563654800e-02
  4.477988628978104000e-01
 -8.920849792999630000e-01
  4.088160743159772700e-01
 -1.923381665902662600e-01
  8.921185162597895500e-01
 -1.282900794494939400e-01
 -5.657902902389501100e-01
  8.145078286831669600e-01
 -7.610746445178878700e-01
 -2.379945106598306500e-01
 -6.034268790564093500e-01
  3.598307176639494700e-01
  8.935166350839126600e-01
 -2.686072922572455600e-01
 -4.154812272145312900e-01
 -8.690380973929711100e-01
  2.686040489492138000e-01
 -8.364927145870304500e-02
  9.358989324345866600e-01
 -3.421929099970210100e-01
 -9.949653023262592400e-01
  7.000451705841460900e-02
  7.171760424215185800e-02
  9.603129175646432100e-01
  7.470557008163993000e-02
  2.687344007700909200e-01
  1.893606689870964400e-01
  1.316803117035090800e-01
  9.730379399337036900e-01
  4.181285321137732100e-01
 -1.714032417145864900e-01
 -8.920703219825847400e-01
  2.702599532881871900e-01
 -5.525481244364640600e-01
  7.884479233471367600e-01
 -2.321767309415800600e-01
 -9.700173139963714800e-01
 -7.183575820262690100e-02
 -1.012426647790757400e-01
 -8.639291360913824400e-01
 -4.933319071789593600e-01
 -7.239654731556316400e-01
  6.860876034909563200e-01
 -7.181778341454755900e-02
 -9.088461126927813700e-01
 -4.169866923911984000e-01
  1.099280727878589000e-02
  3.432828411963250700e-01
  5.103372616810912800e-01
  7.884876475126444400e-01
  5.899998176866607700e-01
  1.741526452599715400e-01
 -7.883977874643368600e-01
  7.945655929676990200e-01
 -6.745760963421351700e-02
  6.034194141509924300e-01
  2.792230250546107200e-01
  8.941667962269657100e-01
  3.500003468634799700e-01
  5.683446402470875300e-01
  6.584687835385576400e-01
  4.933591298513295100e-01
  9.367904449524130400e-01
 -2.315930894917651600e-03
 -3.498832644039295300e-01
 -6.739759707358157200e-01
  5.179169058609690600e-01
  5.268002178189708000e-01
 -3.796037673459364700e-02
  4.502268787131564800e-01
  8.921069260365467300e-01
 -4.259094895013717500e-01
  3.939068773182809500e-01
  8.145173287008949900e-01
 -2.088519805120942200e-01
  9.816483489406069300e-02
  9.730079729510945400e-01
  7.854746442375379900e-01
  3.246631717489930100e-01
  5.268998084738665300e-01
  8.674759521558517200e-01
 -3.610233075403485000e-01
  3.422683798482201700e-01
 -4.663416811098576900e-01
  8.124373127698112400e-01
 -3.499586393832847500e-01
  4.368471395613885400e-01
 -8.966664667886157200e-01
  7.179013855574653500e-02
 -3.710498019453212800e-01
 -2.579753998683734800e-01
  8.920598284527169200e-01];

R=sin(packing_radius*pi/180)*current_radius; % packing_radius is in degrees R=sin(deg*pi/180)*current_radius

len=length(coordinates);
j=1;
i=1;
X=zeros(1,len/3);
Y=zeros(1,len/3);
Z=zeros(1,len/3);

% X=(coordinates(:,1))';
% Y=(coordinates(:,2))';
% Z=(coordinates(:,3))';

while i<=len ,
    X(j)=coordinates(i);
    i=i+1;
    Y(j)=coordinates(i);
    i=i+1;
    Z(j)=coordinates(i);
    i=i+1;
    j=j+1;
end
% plot3(X,Y,Z,'bo');

% -------cartesian to polar-------
rad=sqrt(X.^2+Y.^2+Z.^2);
costheta = (Z./rad);
costheta(isnan(costheta)) = 0;
theta = acos(costheta);  
phi = atan2(Y,X); 
%------------

% figure;
% plot_sphere(rad, theta, phi);
% hold off;

coil_radius_mul=sin(packing_radius*pi/180);
coil_surface_radii= (ones(1,length(Z))*current_radius)';
coil_radii = coil_surface_radii*coil_radius_mul;
current_radius_set=(current_radius*ones(1,length(Z)))';
coil_offsets = (sqrt(current_radius_set.^2 - coil_radii.^2));
coil_rotations=[theta',phi'];
coil_rotations = 180*coil_rotations/pi;
figure;
plot_geometry_sphere(sphereradius,coil_radii,coil_offsets,coil_rotations,[0.1],[0],[0.1],3,'-',[1 0.46 0],0,plot_coil_number_flag)


% end
