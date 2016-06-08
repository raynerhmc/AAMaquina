import pandas as pd
import seaborn as sns
import numpy as np
import scipy
import matplotlib.pyplot as plt


def processing():
	animals = pd.read_csv('/Users/rayner/Documents/Dropbox/Work/Phd/Courses/SCC5871_AAM/Project/Source/orig_train.csv')
	s = pd.Series(animals.AnimalType)
	vc = s.value_counts()
	#vc.plot(kind='bar')
	#sns.countplot(animals.AnimalType, palette='Set3')
	print('vc: ' , vc)
	num_categories = vc.size
	print('num_categories:', num_categories)
	print('values:', vc.values)
	keys = vc.keys();
	print('names:', keys[1])

	xTickMarks = vc.keys()
	print('ticks: ' , xTickMarks)
	fig = plt.figure()
	ax = fig.add_subplot(111)
	# ind = np.arange(num_categories) 
	# width = 3.8
	# rects1 = ax.bar(ind, vc.values, width,
 #                 color='blue', align='center',
 #                 error_kw=dict(elinewidth=2,ecolor='red'))

	# # for x, y, bar in zip(ind, var_nulls, rects1):
	# # 	bar.set_facecolor(cm.jet(var_types[x]))
	# # 	bar.set_alpha(0.5)

	# ax.set_xlabel('Categories', fontsize=18)
	# ax.set_ylabel('Proportion', fontsize=18)
	# ax.set_title('Null values proportion')
	# ax.set_xticks(ind+width)
	# ytickNames = ax.get_yticklabels()
	# x = scipy.arange(3)
	# ax.set_xticks(x)
	# xtickNames = ax.set_xticklabels(xTickMarks)
	# plt.setp(ytickNames, fontsize=16)
	# plt.setp(xtickNames, rotation=90, fontsize=7)
	# plt.axis([-1, 131, 0, 0.55])
	# ax.yaxis.grid(True)
	# print( 'close windows when finished... ')
	plt.show()





if __name__ == '__main__':
  processing()