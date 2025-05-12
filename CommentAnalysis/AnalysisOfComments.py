import pandas as pd
import matplotlib.pyplot as plt
from wordcloud import WordCloud, STOPWORDS

# Step 1: Load the CSV file
file_path = 'Comments.csv'
df = pd.read_csv(file_path)

# Step 2: Specify the four columns
columns = ['GoogleMedical', 'ChatGPTMedical', 'GoogleTrip', 'ChatGPTTrip']

# Add custom stopwords
custom_stopwords = STOPWORDS.union({'chatgpt', 'google'})

# Step 3: Generate and display word clouds
plt.figure(figsize=(20, 10))

for i, col in enumerate(columns, 1):
    text = ' '.join(df[col].dropna().astype(str))
    wordcloud = WordCloud(
        width=800,
        height=400,
        background_color='white',
        stopwords=custom_stopwords
    ).generate(text)

    wordcloud.to_file(f"{col}_wordcloud.png")

    plt.subplot(2, 2, i)
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis('off')
    plt.title(f'Word Cloud for Column: {col}', fontsize=16)

plt.tight_layout()
plt.show()
