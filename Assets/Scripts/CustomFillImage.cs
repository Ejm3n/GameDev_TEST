using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using System.Collections;

[RequireComponent(typeof(Image))]
public class CustomFillImage : MonoBehaviour
{
    [SerializeField] private float fillTime = 5f; // Время заполнения в секундах
    private Material material;
    private bool isFilling = false;

    void Start()
    {
        material = GetComponent<Image>().material;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space)) 
        {
            if (isFilling)
            {
                StopAllCoroutines(); 
            }

            StartCoroutine(FillEffect());
        }
    }

    IEnumerator FillEffect()
    {
        isFilling = true;
        float timer = 0;

        while (timer <= fillTime)
        {
            timer += Time.deltaTime;
            float fillAmount = timer / fillTime;
            material.SetFloat("_FillAmount", 0 + fillAmount); 
            yield return null;
        }

        material.SetFloat("_FillAmount", 1f); 
        isFilling = false;
    }
}
