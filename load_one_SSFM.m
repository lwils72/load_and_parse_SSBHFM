clear
addpath kluttrell_local
setenv('PATH', [getenv('PATH') ':/usr/local/bin']);

%
%   Load L&P station results and L&P EQ station pair Fast
%   Directions
%
    BHinfile='dats/Table_S1.csv';
    FMinfile='dats/FM_subsets_asof_20210615.shmax';
    SSinfile='dats/LiPeng2017tableS3.csv';
   [B,S,L,F,Regions,P]=load_and_parse_SSBHFM(BHinfile,FMinfile,SSinfile);
    
%
%   This excludes SS that are not in the LA basin 
%
     iLA=find(L.Y>P.R2(3) & L.Y<P.R2(4) & L.X>P.R2(1) & L.X<P.R2(2)); %list of iLA
     L.stationlon=L.stationlon(iLA);
     L.stationlat=L.stationlat(iLA);
     L.station=L.station(iLA);
     L.Nmeasurements=L.Nmeasurements(iLA);
     L.ResultantLength=L.ResultantLength(iLA);
     L.FastDirection=L.FastDirection(iLA);
     L.DelayTime=L.DelayTime(iLA);
     L.DelayTimeSTD=L.DelayTimeSTD(iLA);
     L.X=L.X(iLA);
     L.Y=L.Y(iLA);
     S.L_SHmax=S.L_SHmax(iLA,:,:);
     S.L_dSHmax=S.L_dSHmax(iLA,:,:);

%
% Load and look at whatever is available From the Li and Peng supplemnt,
% I believe this is what we are wanting to try to replicate?
%
  % FILENAME='dats/LiPeng2017tableS1.csv'; %RAW SWS measurements (230k of them)
   FORMAT=['%s %s ',repmat('%f ',1,23),repmat('%s ',1,4),'%f %s ',repmat('%f ',1,4),'%s ',repmat('%f ',1,5)];
  % [~,r]=system(['cat ',FILENAME,' | grep -v cant']);
  % C=textscan(r,FORMAT,'headerlines',1,'delimiter',',');

   FILENAME='dats/LiPeng2017tableS2.csv'; %HiQuality SWS measurements (90k of them)
   fid=fopen(FILENAME);
   C=textscan(fid,FORMAT,'headerlines',1,'delimiter',',');
   fclose(fid);

  Leq.eventid=C{1}; % e.g., 15199577.CE.11369.HN
  Leq.station=C{2}; % e.g., 11369
  Leq.stationlat=C{3}; % e.g., 33.037
  Leq.stationlon=C{4}; % e.g., -115.624
  Leq.cuspid=C{5}; % e.g., 15199577
  Leq.year=C{6}; % e.g., 2012
  Leq.doy_det=C{7}; % e.g., 239.803
  Leq.eventlat=C{8}; % e.g., 33.0091
  Leq.eventlon=C{9}; % e.g., -115.553
  Leq.dist_event2station=C{10}; % e.g., 7.27946
  Leq.eventdepth=C{11}; % e.g., 9.064
  Leq.eventmag=C{12}; % e.g., 3.95
  Leq.backaz=C{13}; % e.g., 115.173
  Leq.spol=C{14}; % e.g., 96.665
  Leq.Dspol=C{15}; % e.g., 6.090
  Leq.wbeg=C{16}; % e.g., 4.414999
  Leq.wend=C{17}; % e.g., 5.704518
  Leq.dist_ruap_km=C{18}; % e.g., 
  Leq.dist_ruap_deg=C{19}; % e.g., 
  Leq.SNR=C{20}; % e.g., 21.0769
  Leq.tlag=C{21}; % e.g., 0.282500
  Leq.Dtlag=C{22}; % e.g., 0.005625
  Leq.fast=C{23}; % e.g., -21
  Leq.Dfast=C{24}; % e.g., 7.250
  Leq.anginc=C{25}; % e.g., 37.8 
  Leq.anginc_corr=C{26}; % e.g., anginc_corr
  Leq.type_ini=C{27}; % e.g., ass_5_16
  Leq.time=C{28}; % e.g., Sep
  Leq.comment=C{29}; % e.g., comment
  Leq.nyquist=C{30}; % e.g., 50
  Leq.gradeABCNR=C{31}; % e.g., ACl
  Leq.filt_lo=C{32}; % e.g., 
  Leq.filt_HI=C{33}; % e.g., 
  Leq.spolfastdiff=C{34}; % e.g., 62.335
  Leq.bandang=C{35}; % e.g., -29.6008
  Leq.pickgrade=C{36}; % e.g., UNDEFINE
  Leq.lambdamax=C{37}; % e.g., 3.6068532
  Leq.ndf=C{38}; % e.g., 25
  Leq.lambda2_min=C{39}; % e.g., 0.2680662E+06
  Leq.ttime=C{40}; % e.g., 3.69
  Leq.maxfreq=C{41}; % e.g., 4.45822

%
% OK, to get them all loaded, just pull out what we want
%

%   FILENAME='dats/LiPeng2017tableS1.csv'; %RAW SWS measurements (230k of them)
%   [~,r]=system(['cat ',FILENAME,' | grep -v cant | sed ''1d'' | awk -F, ''{print $4,$3,$9,$8,$11,$23}''']);
%   C=textscan(r,'%f %f %f %f %f %f');
% 
%   Leq.stationlon=C{1}; % e.g., -115.624
%   Leq.stationlat=C{2}; % e.g., 33.037
%   Leq.eventlon=C{3}; % e.g., -115.553
%   Leq.eventlat=C{4}; % e.g., 33.0091
%   Leq.eventdepth=C{5}; % e.g., 9.064
%   Leq.fast=C{6}; % e.g., -21
     
%
% OK, now load the "summary" version
%
  fid=fopen('dats/LiPeng2017tableS3.csv');
  C=textscan(fid,'%s %f %f %f %f %f %f %f','headerlines',1,'delimiter',',');
  fclose(fid);

  L.station=C{1};
  L.stationlon=C{2};
  L.stationlat=C{3};
  L.Nmeasurements=C{4};
  L.ResultantLength=C{5};
  L.FastDirection=C{6}; % deg E of N
  L.DelayTime=C{7};
  L.DelayTimeSTD=C{8};

  % convert to UTM km
  [L.X,L.Y]=ll2utm(L.stationlat,L.stationlon);
  L.X=L.X/1e3;
  L.Y=L.Y/1e3;

  % Track the Y&H FM SHmax directions, at the location of the seismic stations
  [~,r]=system('cat dats/LiPeng2017tableS3.csv | sed ''1d'' | awk -F, ''{print $2,$3}'' | gmt grdtrack -Ggrds/Yang.FMSHmax.grd -Z');
  C=textscan(r,'%f');
  L.FMSHmax=C{1};   
  
%
%   Pick a specific station and try to reproduce their mean fast directions
%   so identify all EQs within the shear wave window under seismometer 
%   REMEMBER- Shear wave windows: epicenter distance less than hypocenter depth.
%

% figure(99),clf,plot3(L.stationlon,L.stationlat,1:numel(L.station),'.')
% used to pick specific station 

  iOneSS=177 % to change which station 
  OneSSname=L.station{iOneSS}; % JNH2 code for station
  ieqOneSS=find(strcmp(Leq.station,OneSSname));
  Leq.fast(ieqOneSS); % fast direction of those 20 eqs
  L.FastDirection(iOneSS) 
  
%
%   to use circ_mean need to convert angles to radians
%

% r2d(angle(mean(exp(d2r(L.FastDirection*2)*i))))/2
% sum(cosd(L.FastDirection))=y
% sum(sind(L.FastDirection))=x
THEmean=atand(sum(sind(L.FastDirection)/sum(cosd(L.FastDirection)))) %atand(x/y)
% THEmean=atand(sum(sind(L.FastDirection*2)/sum(cosd(L.FastDirection*2)))) %atand(x/y)  

%
%   Possibly generate histogram to show the 20 fast directions vs the mean
%   plot various results for each of the pairs L(summary nums) vs Leq(all data)
%   play around see what all fits and makes sense... 
%   calculate the circular mean fast direction 
%

figure(20),clf
histogram(Leq.fast(ieqOneSS),(-90:10:90));
xlabel('Fast Direction Degrees')
ylabel('Number of EQs pairs')
title(['Histogram Fast Directions for station ',OneSSname])
hold on
plot(L.FastDirection(iOneSS)*[1 1],ylim)

%
%   Only graphing the fast directions and the single mean 
%

% figure(61),clf
% plot(L.FastDirection(iOneSS),'^','linewidth',1)
% plot(Leq.fast,'^','linewidth',1)
% axis equal,xlim([-30,120]),ylim([-90,90]),grid
% xticks((-30:30:120)),yticks((-90:30:90))
% 
% figure(62),clf
% plot(L.FastDirection(iOneSS),'^','linewidth',1)
% plot(Leq.fast(iOneSS),'^','linewidth',1)
% axis equal,xlim([-30,120]),ylim([-90,90]),grid
% xticks((-30:30:120)),yticks((-90:30:90))
% 
%  figure(70),clf
%  plot(L.FastDirection,Leq.fast(iOneSS),'^','linewidth',1)
%   
%  figure(71),clf
%  plot(L.FastDirection,Leq.fast(iOneSS),'^','linewidth',1)
% 
% figure(80),clf
% plot(Leq.stationlon,Leq.stationlat,'k^')
% hold on, plot(L.X(:,1),L.Y(:,2),'-k')
% scatter(Leq.eventlon,L.eventlat,5,Leq.eventdepth,'filled'),colorbar

